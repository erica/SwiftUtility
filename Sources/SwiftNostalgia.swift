/*
 
 ericasadun.com
 Sometimes letting go doesn't mean saying goodbye
 
 */

prefix operator ++
prefix operator --
postfix operator ++
postfix operator --

@discardableResult
prefix public func ++(x: inout Int)    -> Int      { x = x + 1; return x }
@discardableResult
prefix public func ++(x: inout UInt)   -> UInt     { x = x + 1; return x }
@discardableResult
prefix public func --(x: inout Int)    -> Int      { x = x - 1; return x }
@discardableResult
prefix public func --(x: inout UInt)   -> UInt     { x = x - 1; return x }


@discardableResult
postfix public func ++(x: inout Int)   -> Int      { defer { x = x + 1 }; return x }
@discardableResult
postfix public func ++(x: inout UInt)  -> UInt     { defer { x = x + 1 }; return x }
@discardableResult
postfix public func --(x: inout Int)   -> Int      { defer { x = x - 1 }; return x }
@discardableResult
postfix public func --(x: inout UInt)  -> UInt     { defer { x = x - 1 }; return x }

@discardableResult
prefix public func ++(x: inout Int16)  -> Int16    { x = x + 1; return x }
@discardableResult
prefix public func ++(x: inout UInt16) -> UInt16   { x = x + 1; return x }
@discardableResult
prefix public func --(x: inout Int16)  -> Int16    { x = x - 1; return x }
@discardableResult
prefix public func --(x: inout UInt16) -> UInt16   { x = x - 1; return x }


@discardableResult
postfix public func ++(x: inout Int16)  -> Int16   { defer { x = x + 1 }; return x }
@discardableResult
postfix public func ++(x: inout UInt16) -> UInt16  { defer { x = x + 1 }; return x }
@discardableResult
postfix public func --(x: inout Int16)  -> Int16   { defer { x = x - 1 }; return x }
@discardableResult
postfix public func --(x: inout UInt16) -> UInt16  { defer { x = x - 1 }; return x }

@discardableResult
prefix public func ++(x: inout Int32)   -> Int32   { x = x + 1; return x }
@discardableResult
prefix public func ++(x: inout UInt32)  -> UInt32  { x = x + 1; return x }
@discardableResult
prefix public func --(x: inout Int32)   -> Int32   { x = x - 1; return x }
@discardableResult
prefix public func --(x: inout UInt32)  -> UInt32  { x = x - 1; return x }


@discardableResult
postfix public func ++(x: inout Int32)  -> Int32   { defer { x = x + 1 }; return x }
@discardableResult
postfix public func ++(x: inout UInt32) -> UInt32  { defer { x = x + 1 }; return x }
@discardableResult
postfix public func --(x: inout Int32)  -> Int32   { defer { x = x - 1 }; return x }
@discardableResult
postfix public func --(x: inout UInt32) -> UInt32  { defer { x = x - 1 }; return x }

@discardableResult
prefix public func ++(x: inout Int64)   -> Int64   { x = x + 1; return x }
@discardableResult
prefix public func ++(x: inout UInt64)  -> UInt64  { x = x + 1; return x }
@discardableResult
prefix public func --(x: inout Int64)   -> Int64   { x = x - 1; return x }
@discardableResult
prefix public func --(x: inout UInt64)  -> UInt64  { x = x - 1; return x }


@discardableResult
postfix public func ++(x: inout Int64)  -> Int64   { defer { x = x + 1 }; return x }
@discardableResult
postfix public func ++(x: inout UInt64) -> UInt64  { defer { x = x + 1 }; return x }
@discardableResult
postfix public func --(x: inout Int64)  -> Int64   { defer { x = x - 1 }; return x }
@discardableResult
postfix public func --(x: inout UInt64) -> UInt64  { defer { x = x - 1 }; return x }

@discardableResult
prefix public func ++(x: inout Int8)    -> Int8    { x = x + 1; return x }
@discardableResult
prefix public func ++(x: inout UInt8)   -> UInt8   { x = x + 1; return x }
@discardableResult
prefix public func --(x: inout Int8)    -> Int8    { x = x - 1; return x }
@discardableResult
prefix public func --(x: inout UInt8)   -> UInt8   { x = x - 1; return x }


@discardableResult
postfix public func ++(x: inout Int8)   -> Int8    { defer { x = x + 1 }; return x }
@discardableResult
postfix public func ++(x: inout UInt8)  -> UInt8   { defer { x = x + 1 }; return x }
@discardableResult
postfix public func --(x: inout Int8)   -> Int8    { defer { x = x - 1 }; return x }
@discardableResult
postfix public func --(x: inout UInt8)  -> UInt8   { defer { x = x - 1 }; return x }

