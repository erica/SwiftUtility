/*
 
 A collection of interesting things to keep on hand
 
 */


/// Courtesy of Tim Vermeulen
/// "I have an object that should logically only be identifiable by its pointer address,
/// and I want to use it as the key in a dictionary"
protocol AutoHashable: class, Hashable {}

extension AutoHashable {
    static func == (left: Self, right: Self) -> Bool {
        return left === right
    }
    
    var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}

import Dispatch

/// I can't remember where I found this or who it is from
/// But I jotted it down anyway
func perform(_ f: () -> Void, simultaneouslyWith g: () -> Void,
             on queue: DispatchQueue) {
    withoutActuallyEscaping(f) { escapableF in
        withoutActuallyEscaping(g) { escapableG in
            queue.async(execute: escapableF)
            queue.async(execute: escapableG)
            queue.sync(flags: .barrier) {}
        }
    }
}

infix operator |> : VeryLowPrecedence

/// Pipe-forward, courtesy of Ben Cohen
///
/// ```
/// let words = ["five","four","three","two","one","blastoff!"]
/// ((0...5).reversed() |> { zip($0, words) })
///    .forEach { print($0.0,$0.1, separator: ": ") }
/// ```
func |> <T,U>(lhs: T, rhs: (T)->U) -> U {
    return rhs(lhs)
}

//-----------------------------------------------------------------------------
// MARK: Clamp to Range
//-----------------------------------------------------------------------------

/// Returns nearest possible value that falls within the closed range
public func clamp<T: Comparable>(_ value: T, to range: ClosedRange<T>) -> T {
    return max(min(value, range.upperBound), range.lowerBound)
}


//-----------------------------------------------------------------------------
// MARK: Adding Optionality
//-----------------------------------------------------------------------------

postfix operator +?
// postfix operator +? : LeftAssociativePrecedence // will not compile

/// Adds optionality by wrapping the
/// rhs value in an Optional enumeration
///
/// - Parameter lhs: a value
/// - Returns: The value wrapped as an Optional
/// ```
/// let x = 42+? // x is Int?
/// ```
public postfix func +?<T>(lhs: T) -> T? { return Optional(lhs) }

//-----------------------------------------------------------------------------
// MARK: HIGH PRECEDENCE COALESCING
//-----------------------------------------------------------------------------

infix operator .?? : HighPrecedence

/// A high-precedence coalescing nil,
/// ensuring that coalescing occurs to
/// produce a value before applying value
/// to other operations
/// - Parameter lhs: an optional value
/// - Parameter rhs: a non-optional fallback value
/// - Returns: The coalesced result of `lhs ?? rhs`
///   performed at high precedence
/// ```
/// let x = Optional(42)
/// let y = 5 + x ?? 2 // won't compile
/// let y = 5 + x .?? 2 // will compile
/// ```
public func .??<T>(lhs: T?, rhs: T) -> T {
    return lhs ?? rhs
}


//-----------------------------------------------------------------------------
// MARK: CONDITIONAL FORCE UNWRAP
//-----------------------------------------------------------------------------

public struct MappingUnwrappingError: Error{}

infix operator .?! : VeryHighPrecedence

/// Performs an in-line operator-based `flatMap` with
/// forced unwrap.
/// - Parameter lhs: the operand
/// - Parameter transform: A closure that accepts
///   an optional value as its argument and returns
///   an optional value.
/// - throws: MappingUnwrappingError
public func .?!<T, U>(lhs: T?, transform: (T) throws -> U?) throws -> U {
    guard let result = try lhs.flatMap(transform)
        else { throw MappingUnwrappingError() }
    return result
}

/// Performs an in-line operator-based map with forced unwrap
/// - Parameter lhs: the operand
/// - Parameter transform: A closure that accepts
///   an optional value as its argument and returns
///   an non-optional value.
/// - throws: MappingUnwrappingError
public func .?!<T, U>(lhs: T?, transform: (T) throws -> U) throws -> U {
    guard let result = try lhs.map(transform)
        else { throw MappingUnwrappingError() }
    return result
}


