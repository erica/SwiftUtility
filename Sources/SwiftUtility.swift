import Foundation

//-----------------------------------------------------------------------------
// MARK: Time Test
//-----------------------------------------------------------------------------

// Prints the elapsed time to execute a block under whatever optimization
// conditions are currently in use by the compiler
public func timetest(_ note: String, block: () -> Void) {
    print("Starting Test:", note)
    let now = ProcessInfo().systemUptime
    block()
    let timeInterval = ProcessInfo().systemUptime - now
    print("Ending Test:", note); print("Elapsed time: \(timeInterval)")
}


//-----------------------------------------------------------------------------
// MARK: Immutable Assignment
//-----------------------------------------------------------------------------

/// Returns `item` after calling `update` to inspect and possibly
/// modify it.
///
/// If `T` is a value type, `update` uses an independent copy
/// of `item`. If `T` is a reference type, `update` uses the
/// same instance passed in, but it can substitute a different
/// instance by setting its parameter to a new value.
@discardableResult
public func with<T>(_ item: T, update: (inout T) throws -> Void) rethrows -> T {
    var this = item
    try update(&this)
    return this
}

//-----------------------------------------------------------------------------
// MARK: Default class reflection
//
// Thanks, Mike Ash
//-----------------------------------------------------------------------------

/// Provides a better default representation for reference types than the class name
public protocol DefaultReflectable: CustomStringConvertible {}

/// A default implementation to enable class members to display their values
extension DefaultReflectable {
    
    /// Constructs a better representation using reflection
    internal func DefaultDescription<T>(instance: T) -> String {
        
        let mirror = Mirror(reflecting: instance)
        let chunks = mirror.children.map({
            (label: String?, value: Any) -> String in
            guard let label = label else { return "\(value)" }
            return value is String ?
                "\(label): \"\(value)\"" : "\(label): \(value)"
        })
        
        if chunks.isEmpty { return "\(instance)" }
        let chunksString = chunks.joined(separator: ", ")
        return "\(mirror.subjectType)(\(chunksString))"
    }
    
    /// Conforms to CustomStringConvertible
    public var description: String { return DefaultDescription(instance: self) }
}

//-----------------------------------------------------------------------------
// MARK: Clamp to Range
//-----------------------------------------------------------------------------

/// Returns nearest possible value that falls within the closed range
public func clamp<T: Comparable>(_ value: T, to range: ClosedRange<T>) -> T {
    return max(min(value, range.upperBound), range.lowerBound)
}

//-----------------------------------------------------------------------------
// MARK: Flat Map 2
//-----------------------------------------------------------------------------

/// Returns a tuple of parameters if all are `.Some`, `nil` otherwise
public func zip<T, U>(_ first: T?, _ second: U?) -> (T, U)? {
    return first.flatMap({ firstItem in
        second.flatMap({ secondItem in
            return (firstItem, secondItem)
        })
    })
}

/// Returns a tuple-parameterized version of the passed function
/// Via Brent R-G
func splatted<T, U, V>(_ function: @escaping (T, U) -> V) -> ((T, U)) -> V {
    return { tuple in function(tuple.0, tuple.1) }
}

/// Evaluates the given closure when two `Optional` instances are not `nil`,
/// passing the unwrapped values as parameters. (Thanks, Mike Ash)
public func flatMap2<T, U, V>(_ first: T?, _ second: U?, _ transform: (T, U) throws -> V?) rethrows -> V? {
    return try zip(first, second).flatMap { try transform($0.0, $0.1) }
}
