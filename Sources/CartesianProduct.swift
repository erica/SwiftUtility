// https://gist.github.com/erica/0aad0d8fc0b7a982e542c4b28ce53fc5

/// Creates a sequence of pairs built of the Cartesian product of two
/// underlying sequences.
/// - Parameter seq1: The first sequence or collection
/// - Parameter seq2: The second sequence or collection
/// - Returns: A sequence of tuple pairs, where the elements of each pair are
///   corresponding elements of `Seq1` and `Seq2`.
/// - Warning: `seq2` must be a multipass (not single-pass) sequence
public func product<Seq1, Seq2>
    (_ seq1: Seq1, _ seq2: Seq2) -> CartesianSequence<Seq1, Seq2>
{
    return CartesianSequence(seq1, seq2)
}

/// A sequence of pairs built out of the Cartesian product of
/// two underlying sequences.
public struct CartesianSequence <Seq1 : Sequence, Seq2 : Sequence>: Sequence
{
    /// A type whose instances produce the ordered elements of this sequence
    public typealias Iterator = CartesianIterator<Seq1, Seq2>
    
    /// Returns an iterator over the elements of this sequence.
    public func makeIterator() -> CartesianIterator<Seq1, Seq2> {
        return Iterator(_seq1, _seq2)
    }
    
    /// Creates an instance that makes pairs of elements from the
    /// Cartesian product of `seq1` and `seq2`.
    public init(_ seq1: Seq1, _ seq2: Seq2) {
        (_seq1, _seq2) = (seq1, seq2)
    }
    
    internal let _seq1: Seq1
    internal let _seq2: Seq2
}

/// An iterator for `CartesianSequence`.
public struct CartesianIterator<Seq1: Sequence, Seq2: Sequence>: IteratorProtocol
{
    /// The type of element returned by `next()`.
    public typealias Element = (Seq1.Iterator.Element, Seq2.Iterator.Element)
    
    /// Creates an instance around a pair of underlying iterators.
    internal init(_ seq1: Seq1, _ seq2: Seq2) {
        let _sequence = seq1.lazy.flatMap ({
            item1 in seq2.lazy.map ({
                item2 in (item1, item2)
            })
        })
        _iterator = _sequence.makeIterator()
    }
    
    /// Advances to the next element and returns it
    public mutating func next() ->
        (Seq1.Iterator.Element, Seq2.Iterator.Element)? {
            return _iterator.next()
    }
    
    internal var _iterator: FlattenIterator<
    LazyMapIterator<Seq1.Iterator,
    LazyMapSequence<Seq2, (Seq1.Iterator.Element, Seq2.Iterator.Element)>>>
}
