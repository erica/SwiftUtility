/*
 
 ericasadun.com
 Sometimes letting go doesn't mean saying goodbye
 
 */

/*
 
 note: this should be expandable to any Integer type, but it cannot yet do so
 
 test:
 var x = 5
 print(++x, x, ++x, x, x++, x, x++, x) // 6 6 7 7 7 8 8 9

 */

prefix operator ++ {}
prefix operator -- {}
@discardableResult
prefix public func ++(x: inout Int) -> Int { x = x + 1; return x }
@discardableResult
prefix public func ++(x: inout UInt) -> UInt { x = x + 1; return x }
@discardableResult
prefix public func --(x: inout Int) -> Int { x = x - 1; return x }
@discardableResult
prefix public func --(x: inout UInt) -> UInt { x = x - 1; return x }


postfix operator ++ {}
postfix operator -- {}
@discardableResult
postfix public func ++(x: inout Int) -> Int { defer { x = x + 1 }; return x }
@discardableResult
postfix public func ++(x: inout UInt) -> UInt { defer { x = x + 1 }; return x }
@discardableResult
postfix public func --(x: inout Int) -> Int { defer { x = x - 1 }; return x }
@discardableResult
postfix public func --(x: inout UInt) -> UInt { defer { x = x - 1 }; return x }


// THIS WORKS
prefix operator ++* {}
prefix public func ++* <T: Integer>( x: inout T) -> T {
    x = x + 1; return x
}

// THIS DOESN'T WORK
/*
prefix operator ++ {}
prefix public func ++ <T: Integer>( x: inout T) -> T {
    x = x + 1; return x
}
*/
// BUG REPORT FILED
