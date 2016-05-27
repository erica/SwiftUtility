/*
 
 ericasadun.com
 Sometimes letting go doesn't mean saying goodbye
 
 */

prefix operator ++ {}
// @discardableResult
prefix public func ++(inout x: Int) -> Int { x = x + 1; return x }
// @discardableResult
prefix public func ++(inout x: UInt) -> UInt { x = x + 1; return x }


postfix operator ++ {}
// @discardableResult
postfix public func ++(inout x: Int) -> Int { x = x + 1; return x - 1 }
// @discardableResult
postfix public func ++(inout x: UInt) -> UInt { x = x + 1; return x - 1 }
