/*

Erica Sadun, http://ericasadun.com

*/

//-----------------------------------------------------------------------------
// MARK: Casting
//-----------------------------------------------------------------------------

infix operator --> {}

/// The ashcast: a better cast. Thanks Mike Ash
func --><T, U>(value: T, target: U.Type) -> U? {
    guard sizeof(T.self) == sizeof(U.self) else { return nil }
    return unsafeBitCast(value, target)
}

//-----------------------------------------------------------------------------
// MARK: Postfix Printing
//-----------------------------------------------------------------------------

postfix operator *** {}

/// Postfix printing for quick playground tests
public postfix func *** <T>(item: T) -> T {
    print(item); return item
}


//-----------------------------------------------------------------------------
// MARK: Conditional Assignment
//-----------------------------------------------------------------------------

infix operator =? {}

/// Conditionally assign optional value to target via unwrapping
/// Thanks, Mike Ash
func =?<T>(inout target: T, newValue: T?) {
    if let unwrapped = newValue { target = unwrapped }
}


//-----------------------------------------------------------------------------
// MARK: In-Place Value Assignment
//-----------------------------------------------------------------------------

infix operator <- {}

/// Replace the value of `a` with `b` and return the old value.
/// The EridiusAssignment courtesy of Kevin Ballard
public func <- <T>(inout a: T, b: T) -> T {
    var value = b; swap(&a, &value); return value
}

// --------------------------------------------------
// MARK: Chaining
// --------------------------------------------------

infix operator >>> { associativity left }

/// Failable chaining
public func >>><T, U>(x: T?, f: T -> U?) -> U? {
    if let x = x { return f(x) }
    return nil
}

/// Direct chaining
public func >>><T, U>(x: T, f: T -> U) -> U {
    return f(x)
}

//-----------------------------------------------------------------------------
// MARK: Floating point equality (David Sweeris)
//-----------------------------------------------------------------------------

// All courtesy of David Sweeris from
// Swift-Evolution mailing list

infix operator ≈ {precedence 255}
func ≈ (value: Double, tolerance: Double) -> (value: Double, tolerance: Double) {
    return (value: value, tolerance: tolerance)
}
func == (lhs: Double, rhs: (value: Double, tolerance: Double)) -> Bool {
    return ((rhs.value - rhs.tolerance)...(rhs.value + rhs.tolerance)) ~= lhs
}

// e.g. 3.0 == 3.01 ≈ 0.001 // false
// e.g. 3.0 == 3.01 ≈ 0.01 // true


//-----------------------------------------------------------------------------
// MARK: Default class reflection
//
// Thanks, Mike Ash
//-----------------------------------------------------------------------------

public protocol DefaultReflectable: CustomStringConvertible {}
extension DefaultReflectable {
    internal func DefaultDescription<T>(instance: T) -> String {
        let mirror = Mirror(reflecting: instance)
        let chunks = mirror.children.map({
            (label: String?, value: Any) -> String in
            if let label = label {
                if value is String {
                    return "\(label): \"\(value)\""
                }
                return "\(label): \(value)"
            } else {
                return "\(value)"
            }
        })
        if chunks.count > 0 {
            let chunksString = chunks.joinWithSeparator(", ")
            return "\(mirror.subjectType)(\(chunksString))"
        } else {
            return "\(instance)"
        }
    }
    
    // Conform to CustomStringConvertible
    public var description: String {
        return DefaultDescription(self)
    }
}

//-----------------------------------------------------------------------------
// MARK: Immutable Assignment
//
// `let carol: Person = with(john) { $0.firstName = "Carol" }`
//-----------------------------------------------------------------------------

/*
 Note from Sean Heber: "I don’t know if it’s a huge advantage or not, but with warnings on unused results, using a with() that has a return with a class instance would mean you’d have to discard the return result explicitly or pointlessly reassign the results to your instance (thus meaning not using a let) just to avoid the warning. If you annotated the with() to allow discarding the result, then it’d be error-prone for structs. It seemed “safer” to me to have a pair."
 
 func with<T>(inout this: T, @noescape using: inout T->Void) { using(&this) }
 func with<T>(this: T, @noescape using: T->Void) { using(this) }
 
 */

// @discardableResult to be added
// @noescape needs to move to type annotation
// needs to add _ for item
public func with<T>(item: T, @noescape update: (inout T) throws -> Void) rethrows -> T {
    var this = item; try update(&this); return this
}

// @noescape needs to move to type annotation
// needs to add _ for item
public func modify<T>(item: T, @noescape update: (inout T) throws -> Void) rethrows {
    var this = item; try update(&this)
}

// These are Sean's with a rename from "with" to "tweak"
func tweak<T>(inout this: T, @noescape using: inout T->Void) { using(&this) }
func tweak<T>(this: T, @noescape using: T->Void) { using(this) }