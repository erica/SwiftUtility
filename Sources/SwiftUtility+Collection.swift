import Foundation

// --------------------------------------------------
// MARK: Collections
// --------------------------------------------------

/// Return the final index in a collection
/// that satisfies a given predicate
func finalIndex<T: Collection>(
    of collection: T,
    where predicate:
    (T.Iterator.Element) -> Bool) -> T.Index?
//    where T.Index == T.Indices.Iterator.Element
{
    for idx in collection.indices.reversed() {
        if predicate(collection[idx]) {
            return idx
        }
    }
    return nil
}

extension Collection
//    where Index == Indices.Iterator.Element
{
    /// Return the final index in a collection
    /// that satisfies a given predicate
    func finalIndex(where predicate:
        (Self.Iterator.Element) -> Bool) -> Self.Index?
    {
        for idx in indices.reversed() {
            if predicate(self[idx]) {
                return idx
            }
        }
        return nil
    }
}


// --------------------------------------------------
// MARK: Fallback
// --------------------------------------------------
extension Dictionary {
    /// Returns non-optional coalescing to fallback value
    subscript(key: Key, fallback fallback: Value) -> Value {
        return self[key] ?? fallback
    }
}

// --------------------------------------------------
// MARK: Wrapping
// --------------------------------------------------

extension Array {
    public subscript(wrap index: Int) -> Element? {
        guard !isEmpty else { return nil }
        // Support negative indices via modulo and
        // adding `count`
        return self[(index % count + count) % count]
    }
}

// --------------------------------------------------
// MARK: Safety
// --------------------------------------------------

extension Collection // where
    // Indices.Iterator.Element: Equatable,
    // Index == Self.Indices.Iterator.Element
{
    /// Returns optional value for safely indexed value
    /// and nil if index is out of bounds
    public subscript(safe index: Self.Index) -> Self.Iterator.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }

    // FIXME: Broken needs fixing
//    /// Returns objects safely collected at existing desired indices.
//    public func objects(collectedAt desiredIndices: Self.Index...) -> [Self.Iterator.Element] {
//        return desiredIndices.flatMap({ self[safe: $0] })
//    }

    // FIXME: Broken needs fixing
//    /// Returns objects safely found at existing desired indices.
//    public func objects(safelyAt desiredIndices: Self.Index...) -> [Self.Iterator.Element?] {
//        return desiredIndices.map({ self[safe: $0] })
//    }
}


// --------------------------------------------------
// MARK: Indexing
// --------------------------------------------------


// FIXME: Broken needs fixing
//extension Collection {
//    /// Returns objects found at existing desired indices.
//    /// No safety guarantees
//    public func objects(at desiredIndices: Self.Index...) -> [Self.Iterator.Element] {
//        return desiredIndices.map({ self[$0] })
//    }
//}

// FIXME: Broken needs fixing
//extension Collection {
//    /// Returns objects found at desired subscript indices.
//    /// No safety guarantees
//    subscript(_ idx1: Self.Index, _ idx2: Self.Index, _ rest: Self.Index...) -> [Self.Iterator.Element] {
//        return [self[idx1], self[idx2]] + rest.lazy.map({ self[$0] })
//    }
//}

// Also from Kevin B
/*
 extension Collection {
    subscript(first: Index, second: Index, rest: Index...) -> [Iterator.Element] {
        var results: [Iterator.Element] = []
        results.reserveCapacity(rest.count + 2)
        results.append(self[first])
        results.append(self[second])
        results.append(rest.lazy.map({ self[$0] }))
        return results
    }
}
*/

// From Kevin B.
extension Collection where Index == Int {
    subscript(indices: IndexSet) -> [Iterator.Element] {
        return indices.map({ self[$0] })
    }
}

// FIXME: Broken needs fixing
//extension Dictionary {
//    /// Returns multiply-scripted dictionary as array of optionals
//    subscript(_ idx1: Key, _ idx2: Key, _ rest: Key...) -> [Value?] {
//        return [self[idx1], self[idx2]] + rest.lazy.map({ self[$0] })
//    }
//}

extension Collection {
    /// Returns a sequence of pairs (*idx*, *x*), where *idx* represents a
    /// consecutive collection index, and *x* represents an element of
    /// the sequence.
    func indexed() -> Zip2Sequence<Self.Indices, Self> {
        return zip(indices, self)
    }
}

