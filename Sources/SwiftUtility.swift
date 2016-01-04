/*

Erica Sadun, http://ericasadun.com

*/

//--------------------------------------------------------------
// MARK: Casting
//--------------------------------------------------------------

infix operator --> {}

/// The ashcast: a better cast. Thanks Mike Ash
func --><T, U>(value: T, target: U.Type) -> U? {
    guard sizeof(T.self) == sizeof(U.self) else { return nil }
    return unsafeBitCast(value, target)
}

//--------------------------------------------------------------
// MARK: Postfix Printing
//--------------------------------------------------------------

postfix operator *** {}

/// Postfix printing for quick playground tests
public postfix func *** <T>(item: T) -> T {
    print(item); return item
}


//--------------------------------------------------------------
// MARK: Conditional Assignment
//--------------------------------------------------------------

infix operator =? {}

/// Conditionally assign optional value to target via unwrapping
/// Thanks, Mike Ash
func =?<T>(inout target: T, newValue: T?) {
    if let unwrapped = newValue { target = unwrapped }
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

//--------------------------------------------------------------
// MARK: Extended Initialization / Chaining
//--------------------------------------------------------------

infix operator •-> {}

/// Prepare instance
func •-> <T>(object: T, @noescape f: (inout T) -> Void) -> T {
    var newValue = object
    f(&newValue)
    return newValue
}

/*
Usage note:

Class:
class MyClass {var (x, y, z) = ("x", "y", "z")}
let myInstance = MyClass() •-> {
    $0.x = "NewX"
    $0.y = "NewY"
}


Struct:
let myFoo = Foo() •-> {
    (inout item: Foo) in
    item.b = 23
}

*/