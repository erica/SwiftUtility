//-----------------------------------------------------------------------------
// MARK: Immutable Assignment
//-----------------------------------------------------------------------------

/// Returns `item` after calling `update` to inspect and possibly
/// modify it.
///
/// If `T` is a value type, `update` uses an independent copy
/// of `item`. If `T` is a reference type, `update` uses the
/// same instance passed in, but it can substitute a different
/// instance by setting its parameter to a new value.
@discardableResult
public func with<T>(_ item: T, update: (inout T) throws -> Void) rethrows -> T {
    var this = item
    try update(&this)
    return this
}

/// Returns a modified reference type
@discardableResult
public func with<T: AnyObject>(_ this: T, update: (T) throws -> Void) rethrows -> T {
    try update(this)
    return this
}
