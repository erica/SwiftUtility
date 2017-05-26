infix operator !! : VeryLowPrecedence

// --------------------------------------------------
// MARK: Controlled Landing
// --------------------------------------------------

/// Forced unwrap with expressive fatal error courtesy of Ben Cohen
///
/// ```
/// let array: [Int] = []
///
/// let lastItem = array.last !! "Expected non-empty array"
/// ```
///
func !! <Wrapped>(optionalValue: Wrapped?, fatalMessage: String) -> Wrapped {
    if let result = optionalValue { return result }
    fatalError(fatalMessage)
}


// --------------------------------------------------
// MARK: More readable `optional.map`
// --------------------------------------------------

/// A more expressive way to perform optional.map(action)
extension Optional {
    public func `do`(perform action: (Wrapped) -> Void) {
        self.map(action)
    }
}

// --------------------------------------------------
// MARK: Map/Flatmap Conditional Application
// --------------------------------------------------

infix operator .? : VeryHighPrecedence

/// Contextually performs an in-line operator `flatMap`.
/// Use for conditionally applying a functional pass-through
/// transformation closure
/// ```
/// optionalInteger.?(String.init)
/// ```
/// - Parameter transform: A closure that accepts
///   an optional value as its argument and returns
///   an optional value.
/// - Parameter lhs: the operand
/// - Note: There is no way to assign this at
///   slightly higher precedence than the
///   `map` version of `.?` Check your output types
public func .?<T, U>(lhs: T?, transform: (T) throws -> U?) rethrows -> U? {
    return try lhs.flatMap(transform)
}

/// Contextually performs an in-line operator `map`.
/// Use for conditionally applying a functional pass-through
/// transformation closure
/// ```
/// optionalInteger.?(String.init)
/// ```
/// - Parameter lhs: the operand
/// - Parameter transform: A closure that accepts
///   an optional value as its argument and returns
///   an non-optional value.
/// - Note: There is no way to assign this at
///   slightly lower precedence than the
///   `flatMap` version of `.?`. Check your output
///   types
public func .?<T, U>(lhs: T?, _ transform: (T) throws -> U) rethrows -> U? {
    return try lhs.map(transform)
}

//-----------------------------------------------------------------------------
// MARK: Zipping optionals
//-----------------------------------------------------------------------------

/// Returns a tuple of parameters if all are `.Some`, `nil` otherwise
public func zip<T, U>(_ first: T?, _ second: U?) -> (T, U)? {
    return first.flatMap({ firstItem in
        second.flatMap({ secondItem in
            return (firstItem, secondItem)
        })
    })
}

/// Evaluates the given closure when two `Optional` instances are not `nil`,
/// passing the unwrapped values as parameters. (Thanks, Mike Ash)
public func flatMap2<T, U, V>(_ first: T?, _ second: U?, _ transform: (T, U) throws -> V?) rethrows -> V? {
    return try zip(first, second).flatMap ({ try transform($0.0, $0.1) })
}

