import Foundation

// --------------------------------------------------
// MARK: - CASTING
// --------------------------------------------------

prefix operator *

/// Performs a groffcast by force casting to
/// the type demanded by static context
///
/// ```
/// var value: Any = 2
/// 1 + *value // 3
/// value = "world"
/// "hello " + *value // "hello world"
/// ```
///
public prefix func *<T>(item: Any) -> T { return item as! T }

infix operator --> : HighPrecedence

/// Perform unsafe bitcast iff the type sizes equate
///
/// ```
/// let int = 42
/// let double = 42 --> Double.self
/// print(double) // Optional(2.0750757125332355e-322)
/// ```
/// - Note: The ashcast: a better cast. Thanks Mike Ash for the assist
public func --><T, U>(item: T, target: U.Type) -> U? {
    guard MemoryLayout<T>.size == MemoryLayout<U>.size else { return nil }
    return unsafeBitCast(item, to: target)
}

infix operator =>

/// Dynamically dispatch a method using dynogroffing
///
/// ```
/// var x: Any = 2
/// (x=>String.hasPrefix)("wor")
/// ```
///
public func =><T, U, V>(item: Any, method: (T) -> (U) -> V) -> (U) -> V {
    return method(item as! T)
}

infix operator ==>

/// Dynamically cast without bridging (The Groffchoo)
///
/// ```
/// var x: Any = NSString(string: "Hello")
/// let y = x ==> NSString.self // "Hello"
/// let z = x ==> String.self // nil
/// ```
///
public func ==><T>(item: Any, destinationType: T.Type) -> T? {
    guard
        let casted = item as? T,
        type(of: item) is T.Type
        else { return nil }
    return casted
}

// --------------------------------------------------
// MARK: - VALUE ASSIGNMENT
// --------------------------------------------------

infix operator <-

/// Replace the value of `a` with `b` and return the old value.
/// The EridiusAssignment courtesy of Kevin Ballard
/// ```
/// var b = "First"
/// let y = a <- "Second"
/// print(a, b) // "Second", "First"/// ```
///
public func <- <T>(originalValue: inout T, newValue: T) -> T {
    var holder = newValue; swap(&originalValue, &holder); return holder
}

infix operator =? : AssignmentPrecedence

/// Conditionally assign optional value to target via unwrapping
/// Thanks, Mike Ash
/// ```
/// var x: Int? = 8
/// var y = 0
/// y =? x // y is now 8
/// x = nil
/// y =? x // y is still 8
///
public func =?<T>(target: inout T, newValue: T?) {
    if let unwrapped = newValue { target = unwrapped }
}

// --------------------------------------------------
// MARK: - CHAINING
// --------------------------------------------------
//
// e.g. let y = (3 + 2) >>> String.init // y is "5"

precedencegroup ChainingPrecedence {
    associativity: left
}
infix operator >>>: ChainingPrecedence

/// Failable chaining
public func >>><T, U>(value: T?, transform: (T) -> U?) -> U? {
    if let value = value { return transform(value) }
    return nil
}

/// Direct chaining
public func >>><T, U>(value: T, transform: (T) -> U) -> U {
    return transform(value)
}
