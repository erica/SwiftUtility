/*

Erica Sadun, http://ericasadun.com

*/

// The ashcast: a better cast. Thanks Mike Ash
infix operator --> {}
func --><T, U>(value: T, target: U.Type) -> U? {
    guard sizeof(T.self) == sizeof(U.self) else {return nil}
    return unsafeBitCast(value, target)
}
