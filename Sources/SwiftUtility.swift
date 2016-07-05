/*
 
 Erica Sadun, http://ericasadun.com
 
 */

import Foundation

//

//-----------------------------------------------------------------------------
// MARK: Casting
//-----------------------------------------------------------------------------

infix operator --> {}

/// Perform unsafe bitcast but only if the sizes equate
/// Will have to be updated post SE-0101
///
/// - Note: The ashcast: a better cast. Thanks Mike Ash for the assist
public func --><T, U>(value: T, target: U.Type) -> U? {
    guard sizeof(T.self) == sizeof(U.self) else { return nil }
    return unsafeBitCast(value, to: target)
}

// The Groffcast Corpus

prefix operator * {}

/// Force-cast `Any` to the type demanded by static context.
///
/// e.g.
/// ```
/// var x: Any = 2
/// 1 + *x
/// x = "world"
/// "hello " + *x
/// ```
///
public prefix func *<T>(x: Any) -> T { return x as! T }

infix operator => {}

/// Dynamically dispatch a method on Any.
///
/// e.g.
/// ```
/// var x: Any = 2
/// (x=>String.hasPrefix)("wor")
/// ```
///
public func =><T, U, V>(myself: Any, method: (T) -> (U) -> V) -> (U) -> V {
    return method(myself as! T)
}


//-----------------------------------------------------------------------------
// MARK: Postfix Printing
//-----------------------------------------------------------------------------

postfix operator *? {}

/// Postfix printing for quick playground tests
public postfix func *?<T>(lhs: T) -> T {
    print(lhs); return lhs
}

//-----------------------------------------------------------------------------
// MARK: In-Place Value Assignment
//-----------------------------------------------------------------------------

infix operator <- {}

/// Replace the value of `a` with `b` and return the old value.
/// The EridiusAssignment courtesy of Kevin Ballard
public func <- <T>(a: inout T, b: T) -> T {
    var value = b; swap(&a, &value); return value
}

//-----------------------------------------------------------------------------
// MARK: Conditional In-Place Assignment
//-----------------------------------------------------------------------------

infix operator =? {}

/// Conditionally assign optional value to target via unwrapping
/// Thanks, Mike Ash
public func =?<T>(target: inout T, newValue: T?) {
    if let unwrapped = newValue {
        target = unwrapped
    }
}

// --------------------------------------------------
// MARK: Chaining
// --------------------------------------------------

infix operator >>> { associativity left }

/// Failable chaining
public func >>><T, U>(x: T?, f: (T) -> U?) -> U? {
    if let x = x { return f(x) }
    return nil
}

/// Direct chaining
public func >>><T, U>(x: T, f: (T) -> U) -> U {
    return f(x)
}

//-----------------------------------------------------------------------------
// MARK: Floating point equality (David Sweeris)
//-----------------------------------------------------------------------------

// All courtesy of David Sweeris from
// Swift-Evolution mailing list

infix operator ≈ {precedence 255}

public typealias ToleranceTuple = (value: Double, tolerance: Double)
public func ≈ (value: Double, tolerance: Double) -> ToleranceTuple {
    return (value: value, tolerance: tolerance)
}

public func == (lhs: Double, rhs: ToleranceTuple) -> Bool {
    return ((rhs.value - rhs.tolerance)...(rhs.value + rhs.tolerance)) ~= lhs
}

// e.g. 3.0 == 3.01 ≈ 0.001 // false
// e.g. 3.0 == 3.01 ≈ 0.01 // true


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
    internal func DefaultDescription<T>(_ instance: T) -> String {

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
    public var description: String { return DefaultDescription(self) }
}

//-----------------------------------------------------------------------------
// MARK: Immutable Assignment
//
// `let carol: Person = with(john) { $0.firstName = "Carol" }`
//-----------------------------------------------------------------------------

/// Returns `item` after calling `update` to inspect and possibly
/// modify it.
///
/// If `T` is a value type, `update` uses an independent copy
/// of `item`. If `T` is a reference type, `update` uses the
/// same instance passed in, but it can substitute a different
/// instance by setting its parameter to a new value.
@discardableResult
public func with<T>(_ item: T, update: @noescape (inout T) throws -> Void) rethrows -> T {
    var this = item
    try update(&this)
    return this
}
