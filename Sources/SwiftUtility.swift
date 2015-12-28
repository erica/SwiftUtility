/*

Erica Sadun, http://ericasadun.com

*/

//--------------------------------------------------------------
// MARK: Casting
//--------------------------------------------------------------

infix operator --> {}

/// The ashcast: a better cast. Thanks Mike Ash
func --><T, U>(value: T, target: U.Type) -> U? {
    guard sizeof(T.self) == sizeof(U.self) else {return nil}
    return unsafeBitCast(value, target)
}

//--------------------------------------------------------------
// MARK: Postfix Printing
//--------------------------------------------------------------

postfix operator *** {}

/// Postfix printing for quick playground tests
public postfix func *** <T>(item: T) -> T {
    print(item)
    return item
}


//--------------------------------------------------------------
// MARK: Conditional Assignment
//--------------------------------------------------------------

infix operator =? {}

/// Conditionally assign optional value to target via unwrapping
/// Thanks, Mike Ash
func =?<T>(inout target: T, newValue: T?) {
    if let unwrapped = newValue {
        target = unwrapped
    }
}