import Foundation

//-----------------------------------------------------------------------------
// MARK: Pass-through Postfix Printing
//-----------------------------------------------------------------------------

postfix operator *?

/// Postfix printing for quick playground tests
/// AKA the "printica" operator
public postfix func *?<T>(lhs: T) -> T {
    print(lhs); return lhs
}

//-----------------------------------------------------------------------------
// MARK: Casting
//-----------------------------------------------------------------------------

prefix operator *

/// Performs the Groffcast: force cast to the type demanded by static context
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

infix operator -->

/// Perform unsafe bitcast but only if the sizes equate
///
/// - Note: The ashcast: a better cast. Thanks Mike Ash for the assist
public func --><T, U>(value: T, target: U.Type) -> U? {
    guard MemoryLayout<T>.size == MemoryLayout<U>.size else { return nil }
    return unsafeBitCast(value, to: target)
}

infix operator =>

/// Dynamically dispatch a method. (Dynogroff)
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

infix operator ==>

/// Dynamically cast without bridging (The Groffchoo)
///
/// e.g.
/// ```
/// var x: Any = NSString(string: "Hello")
/// let y = x ==> NSString.self // "Hello"
/// let z = x ==> String.self // nil
/// ```
///
public func ==><T>(myself: Any, destinationType: T.Type) -> T? {
    guard let casted = myself as? T, type(of: myself) is T.Type else { return nil }
    return casted
}

//-----------------------------------------------------------------------------
// MARK: In-Place Value Assignment
//-----------------------------------------------------------------------------

infix operator <-

/// Replace the value of `a` with `b` and return the old value.
/// The EridiusAssignment courtesy of Kevin Ballard
/// e.g.
/// ```
/// var x = "First"
/// let y = x <- "Second"
/// print(x, y) // "Second", "First"/// ```
///
public func <- <T>(a: inout T, b: T) -> T {
    var value = b; swap(&a, &value); return value
}

//-----------------------------------------------------------------------------
// MARK: Conditional In-Place Assignment
//-----------------------------------------------------------------------------

infix operator =?

/// Conditionally assign optional value to target via unwrapping
/// Thanks, Mike Ash
/// e.g.
/// ```
/// var x: Int? = 8
/// var y = 0
/// y =? x // y is now 8
/// x = nil
/// y =? x // y is still 8
///
public func =?<T>(target: inout T, newValue: T?) {
    if let unwrapped = newValue {
        target = unwrapped
    }
}

// --------------------------------------------------
// MARK: Chaining
// --------------------------------------------------
//
// e.g. let y = (3 + 2) >>> String.init // y is "5"

precedencegroup ChainingPrecedence {
    associativity: left
}
infix operator >>>: ChainingPrecedence


/// Failable chaining
public func >>><T, U>(x: T?, f: (T) -> U?) -> U? {
    if let x = x { return f(x) }
    return nil
}

/// Direct chaining
public func >>><T, U>(x: T, f: (T) -> U) -> U {
    return f(x)
}


