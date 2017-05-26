//-----------------------------------------------------------------------------
// MARK: Splatting
//-----------------------------------------------------------------------------

/// Returns a tuple-parameterized version of the passed function
/// Via Brent R-G
func splatted<T, U, Z>(_ function: @escaping (T, U) -> Z) -> ((T, U)) -> Z {
    return { tuple in function(tuple.0, tuple.1) }
}

/// Returns a tuple-parameterized version of the passed function
/// Via Brent R-G
func splatted<T, U, V, Z>(_ function: @escaping (T, U, V) -> Z) -> ((T, U, V)) -> Z {
    return { tuple in function(tuple.0, tuple.1, tuple.2) }
}

/// Returns a tuple-parameterized version of the passed function
/// Via Brent R-G
func splatted<T, U, V, W, Z>(_ function: @escaping (T, U, V, W) -> Z) -> ((T, U, V, W)) -> Z {
    return { tuple in function(tuple.0, tuple.1, tuple.2, tuple.3) }
}
