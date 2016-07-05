/*

Erica Sadun, http://ericasadun.com

Collections, Sequences, and Strides

Heavily curated. I'm kicking myself for not keeping
better notes.

When in doubt I may have attributed stuff with
assistance entirely to others. If it's gone the
other way, let me know and I'll fix attribution

Still needs massive documentation, tweakage

*/

// -----------------------------------------------------------------------------
// MARK: Non-Optional Dictionary Lookup
// -----------------------------------------------------------------------------

public extension Dictionary {
    public subscript(key: Key, default fallback: Value) -> Value {
        return self[key] ?? fallback
    }
}

// -----------------------------------------------------------------------------
// MARK: Repeats
// -----------------------------------------------------------------------------

public extension Int  {
    /// Repeat a task n times
    public func times(_ task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
    
    /// Repeat a task n times taking an Int parameter
    public func times(_ task: (Int) -> Void) {
        for idx in 0..<self {
            task(idx)
        }
    }
    
    /// Repeat a task n times / Standin to avoid keyword
    public func repetitions(_ task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
    
    /// Repeat a task n times taking an Int parameter / Standin to avoid keyword
    public func repetitions(_ task: (Int) -> Void) {
        for idx in 0..<self {
            task(idx)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: Cartesian Product
// -----------------------------------------------------------------------------

/// Return a lazy Cartesian product of two sequences
public func cartesianProduct<S1: Sequence, S2: Sequence>(_ s1: S1, _ s2: S2) -> AnySequence<(S1.Iterator.Element, S2.Iterator.Element)> {
    let items = s1.lazy.flatMap({
        item1 in s2.lazy.map({
            item2 in (item1, item2)})})
    return AnySequence(items)
}

/// Return a lazy Cartesian product of three sequences
public func cartesianProduct<S1: Sequence, S2: Sequence, S3: Sequence>(_ s1: S1, _ s2: S2, _ s3: S3) -> AnySequence<(S1.Iterator.Element, S2.Iterator.Element, S3.Iterator.Element)> {
    let items = s1.lazy.flatMap({
        item1 in s2.lazy.flatMap({
            item2 in s3.lazy.map({
                item3 in (item1, item2, item3)})})})
    return AnySequence(items)
}

// -----------------------------------------------------------------------------
// MARK: Indexed Enumeration
// -----------------------------------------------------------------------------

public extension Collection {
    /// Return a lazy SequenceType containing pairs *(i, x)*,
    /// where *i*s are the sequential indices and *x*s are the elements of `base`.
    ///
    /// - Author: Nate Cook (I'm pretty sure)
    public func enumerateWithIndices() -> AnySequence<(index: Index, value: Generator.Element)> {
        var index = startIndex
        return AnySequence {
            return AnyIterator {
                guard index != self.endIndex else { return nil }
                let nextIndex = self.index(after: index); defer { index = nextIndex }
                return (index: index, value: self[index])
            }
        }
    }
}

public extension Sequence {
    /// Apply 2-argument (index, element) closure to each member of a sequence
    /// Thanks https://twitter.com/publicfarley/status/630091086971699202
    public func forEachWithIndex( closure: @noescape(Int, Self.Iterator.Element) -> Void) {
        enumerated().forEach{ closure($0.0, $0.1) }
    }
}


// -----------------------------------------------------------------------------
// MARK: Skipped Sequences
// -----------------------------------------------------------------------------

/// A sequence type that incorporates skipping
/// Pretty sure this is assisted or mostly by Mike Ash
/// Although it's ugly enough that it may be mine
public struct Skip<T: Sequence>: Sequence {
    let sequence: T
    let count: Int
    
    public func makeIterator() -> T.Iterator {
        var iterator = sequence.makeIterator()
        for _ in 0 ..< count {
            let _ = iterator.next()
        }
        return iterator
    }
}

public extension Sequence {
    /// Return a sequence that skips n items
    /// Pretty sure this is assisted or mostly by Mike Ash
    /// Although it's ugly enough that it may be mine
    public func skip(count: Int) -> Skip<Self> {
        return Skip(sequence: self, count: count)
    }
}

public extension Sequence {
    /// Enumerate using offset index
    /// Thanks Mike Ash
    public func enumerate(first: Int) -> AnySequence<(Int, Iterator.Element)> {
        return AnySequence(enumerated().lazy.map({ ($0 + first, $1) }))
    }
}

// -----------------------------------------------------------------------------
// MARK: Matching From End
// -----------------------------------------------------------------------------

//FIXME: Using new Swift 3 index model
//public extension Collection where Index: Comparable {
//    /// Return the index of the last element in `self` which returns `true` for `isElement`
//    ///
//    /// - Author: oisdk
//    public func lastIndexOf(isElement: @noescape (Generator.Element) -> Bool) -> Index? {
//        for index in indices.reversed()
//            where isElement(self[index]) {
//                return index
//        }
//        return nil
//    }
//}
//
//public extension CollectionType where Index: BidirectionalIndexType, Generator.Element: Equatable {
//    /// Return the index of the last element in `self` which returns `true` for `isElement`
//    ///
//    /// - Author: oisdk
//    public func lastIndexOf(element: Generator.Element) -> Index? {
//        return lastIndexOf { e in e == element }
//    }
//}

// -----------------------------------------------------------------------------
// MARK: Strides
// -----------------------------------------------------------------------------

// FIXME: New striding model
//public extension Strideable {
//    /// Extend strideable value to a strided sequence through a destination value
//    ///
//    /// Thanks, Mike Ash
//    public func to(other: Self, step:Self.Stride = 1) -> StrideThrough<Self> {
//        let by: Stride = (self < other) ? abs(step) : -abs(step)
//        return stride(through: other, by: by)
//    }
//}

// -----------------------------------------------------------------------------
// MARK: Safe Indexing
// -----------------------------------------------------------------------------

// FIXME: Swift new indexing model
//public extension Collection where Index: Comparable {
//    /// Safe collection indexing
//    /// Thanks Brent Royal-Gordon
//    /// (http://twitter.com/brentdax/status/613894991778222081)
//    public subscript (safe index: Index) -> Generator.Element? {
//        guard indices ~= index else { return nil }
//        return self[index]
//    }
//}

// FIXME: Swift new indexing model
//public extension RangeReplaceableCollection where Index: Comparable {
//    public subscript (safe index: Index) -> Generator.Element? {
//        get {
//            guard indices ~= index else { return nil }
//            return self[index]
//        }
//        set {
//            guard indices ~= index else { return }
//            if let newValue = newValue {
//                self.removeAtIndex(index)
//                self.insert(newValue, atIndex: index)
//            }
//        }
//    }
//    
//    public mutating func removeAtIndex(safe index: Self.Index) -> Self.Generator.Element? {
//        guard indices ~= index else { return nil }
//        return self.removeAtIndex(index)
//    }
//}

// I use UInt vs Int because it makes more sense to me for the
// first two of these but I have sufficient pushback to reconsider
public extension Array {
    public func atIndex(index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
    
    // Thanks Mike Ash
    public subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
        
        // Bryan Luby's variation
        //        return 0..<count ~= Int(index) ? self[Int(index)] : nil
        
        // And my silly take on that
        //        switch Int(index) {
        //        case let i where 0..<count ~= i : return self[i]
        //        default: return nil
        //        }
    }
    
    // Thanks Wooji Juice
    public subscript (wrap index: Int) -> Element? {
        if count == 0 { return nil }
        return self[(index % count + count) % count]
    }
}

// -----------------------------------------------------------------------------
// MARK: Multi-indexed array
// -----------------------------------------------------------------------------

public extension Array {
    /// Return collection at subscripted indices
    public subscript(i1: Int, i2: Int, rest: Int...) ->  [Element] {
        get {
            var result: [Element] = [self[i1], self[i2]]
            for index in rest {
                guard index < count else { continue }
                result.append(self[index])
            }
            return result
        }
        
        // Thanks Big O Note Taker
        set (values) {
            for (index, value) in zip([i1, i2] + rest, values) {
                self[index] = value
            }
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: Nil-padded Zips
// -----------------------------------------------------------------------------

// Sequence zipping and equality
// Thanks, Mike Ash
public func longZip<S0: Sequence, S1: Sequence>(_ seq0: S0, _ seq1: S1) ->
    AnyIterator<(S0.Iterator.Element?, S1.Iterator.Element?)> {
        var iterators = (seq0.makeIterator(), seq1.makeIterator())
        return AnyIterator {
            let items = (iterators.0.next(), iterators.1.next())
            if case (.none, .none) = items { return nil }
            return items
        }
}

infix operator ==== {}
public func ==== <S1: Sequence, S2: Sequence
    where S1.Iterator.Element == S2.Iterator.Element,
    S1.Iterator.Element: Equatable>(seq1: S1, seq2: S2) -> Bool {
        return !longZip(seq1, seq2).contains(!=)
}


/// Courtesy of Donnacha Oisin Kidney:
///
/// "An implementation of this is actually pretty complicated, since you aren’t supposed to call a generator once it’s returned nil."
public struct NilPaddedZipGenerator<G0: IteratorProtocol, G1: IteratorProtocol>: IteratorProtocol {
    
    private var (g0, g1): (G0?, G1?)
    
    public mutating func next() -> (G0.Element?, G1.Element?)? {
        let (e0,e1) = (g0?.next(),g1?.next())
        switch (e0, e1) {
        case (nil, nil): return nil
        case (  _, nil): g1 = nil
        case (nil,   _): g0 = nil
        default: break
        }
        return (e0, e1)
    }
}

// FIXME: New sequence model
//public struct NilPaddedZip<S0: Sequence, S1: Sequence>: LazySequence<(S0.Iterator.Element, S1.Iterator.Element)> {
//    let (s0, s1): (S0, S1)
//    return AnySequence(NilPaddedZipGenerator(g0: s0.makeIterator(), g1: s1.makeIterator()))
//}
//
//@warn_unused_result
//public func zipWithPadding<S0: Sequence, S1: Sequence>(s0: S0, _ s1: S1)
//    -> NilPaddedZip<S0, S1> {
//        return NilPaddedZip(s0: s0, s1: s1)
//}

// -----------------------------------------------------------------------------
// MARK: Collection Maxima
// -----------------------------------------------------------------------------

// FIXME: New sequence model
//public extension Collection where Iterator.Element: Comparable {
//    /// Return index of maximal element in collection
//    /// Thanks Jordan Rose
//    public var maxIndex: Self.Index? {
//        return indices.maxElement({
//            self[$1] > self[$0]
//        })
//    }
//}

// -----------------------------------------------------------------------------
// MARK: Map Values -- thanks, Jonathan Hull
// -----------------------------------------------------------------------------

extension Dictionary {
    
    /// <#Description#>
    ///
    /// - parameter f: <#f description#>
    ///
    /// - returns: <#return value description#>
    func mapValues<U>(f: (Key,Value) -> U) -> [Key: U] {
        var output: [Key: U] = [:]
        for (k, v) in self { output[k] = f(k, v) }
        return output
    }
    
}
