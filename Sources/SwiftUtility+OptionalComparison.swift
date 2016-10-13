// Evaluates the given closure when two `Optional` instances are not `nil`,
// passing the unwrapped values as parameters. (Thanks, Mike Ash, Tim Vermeulen)
// Following the example of IEEE754 with NAN, any comparison involving
// .None is false
//
// See also: http://stackoverflow.com/questions/1565164/what-is-the-rationale-for-all-comparisons-returning-false-for-ieee754-nan-values

// Brent RG has a really interesting take here: https://gist.github.com/brentdax/60460ad4578d5d8d52a9d736240cfea6

fileprivate func _flatMap2<T, U, V>(_ first: T?, _ second: U?, _ transform: (T, U) throws -> V?) rethrows -> V? {
    return try first.flatMap({ first in
        try second.flatMap({ second in
            try transform(first, second) })})
}

// MARK: Failable Optional Comparisons

precedencegroup OptionalComparisonPrecedence {
    higherThan: NilCoalescingPrecedence
}

infix operator <?: OptionalComparisonPrecedence
infix operator <=?: OptionalComparisonPrecedence
infix operator ==?: OptionalComparisonPrecedence
infix operator >?: OptionalComparisonPrecedence
infix operator >=?: OptionalComparisonPrecedence

// MARK: Wrapped Optional Comparison

/// Returns lhs! < rhs!, otherwise nil
public func <? <T: Comparable>(lhs: T?, rhs: T?) -> Bool? { return _flatMap2(lhs, rhs, <) }

/// Returns lhs! <= rhs!, otherwise nil
public func <=? <T: Comparable>(lhs: T?, rhs: T?) -> Bool? { return _flatMap2(lhs, rhs, <=) }

/// Returns lhs! == rhs!, otherwise nil
public func ==? <T: Comparable>(lhs: T?, rhs: T?) -> Bool? { return _flatMap2(lhs, rhs, ==) }

/// Returns lhs! > rhs!, otherwise nil
public func >? <T: Comparable>(lhs: T?, rhs: T?) -> Bool? { return _flatMap2(lhs, rhs, >) }

/// Returns lhs! >= rhs!, otherwise nil
public func >=? <T: Comparable>(lhs: T?, rhs: T?) -> Bool? { return _flatMap2(lhs, rhs, >=) }

// MARK: Wrapped Optional-Nonoptional Comparison

/// Returns lhs! < rhs, otherwise nil
public func <? <T: Comparable>(lhs: T?, rhs: T) -> Bool? { return lhs.map{ $0 < rhs } }

/// Returns lhs! <= rhs, otherwise nil
public func <=? <T: Comparable>(lhs: T?, rhs: T) -> Bool? { return lhs.map{ $0 <= rhs } }

/// Returns lhs! == rhs, otherwise nil
public func ==? <T: Comparable>(lhs: T?, rhs: T) -> Bool? { return lhs.map{ $0 == rhs } }

/// Returns lhs! > rhs, otherwise nil
public func >? <T: Comparable>(lhs: T?, rhs: T) -> Bool? { return lhs.map{ $0 > rhs } }

/// Returns lhs! >= rhs, otherwise nil
public func >=? <T: Comparable>(lhs: T?, rhs: T) -> Bool? { return lhs.map{ $0 >= rhs } }

/// Returns lhs < rhs!, otherwise nil
public func <? <T: Comparable>(lhs: T, rhs: T?) -> Bool? { return rhs.map{ lhs < $0 } }

/// Returns lhs <= rhs!, otherwise nil
public func <=? <T: Comparable>(lhs: T, rhs: T?) -> Bool? { return rhs.map{ lhs <= $0 } }

/// Returns lhs == rhs!, otherwise nil
public func ==? <T: Comparable>(lhs: T, rhs: T?) -> Bool? { return rhs.map{ lhs == $0 } }

/// Returns lhs > rhs!, otherwise nil
public func >? <T: Comparable>(lhs: T, rhs: T?) -> Bool? { return rhs.map{ lhs > $0 } }

/// Returns lhs >= rhs!, otherwise nil
public func >=? <T: Comparable>(lhs: T, rhs: T?) -> Bool? { return rhs.map{ lhs >= $0 } }

// MARK: Unwrapped Optional Comparisons

/// Returns lhs! < rhs!, otherwise false
public func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool { return lhs <? rhs ?? false }

/// Returns lhs! <= rhs!, otherwise false
public func <= <T: Comparable>(lhs: T?, rhs: T?) -> Bool { return lhs <=? rhs ?? false }

/// Returns lhs! == rhs!, otherwise false
public func == <T: Comparable>(lhs: T?, rhs: T?) -> Bool { return lhs ==? rhs ?? false }

/// Returns lhs! > rhs!, otherwise false
public func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool { return lhs >? rhs ?? false }

/// Returns lhs! >= rhs!, otherwise false
public func >= <T: Comparable>(lhs: T?, rhs: T?) -> Bool { return lhs >=? rhs ?? false }

// MARK: Unwrapped Optional-Nonoptional Comparisons

/// Returns lhs < rhs!, otherwise false
public func < <T: Comparable>(lhs: T, rhs: T?) -> Bool { return lhs <? rhs ?? false }

/// Returns lhs <= rhs!, otherwise false
public func <= <T: Comparable>(lhs: T, rhs: T?) -> Bool { return lhs <=? rhs ?? false }

/// Returns lhs == rhs!, otherwise false
public func == <T: Comparable>(lhs: T, rhs: T?) -> Bool { return lhs ==? rhs ?? false }

/// Returns lhs > rhs!, otherwise false
public func > <T: Comparable>(lhs: T, rhs: T?) -> Bool { return lhs >? rhs ?? false }

/// Returns lhs >= rhs!, otherwise false
public func >= <T: Comparable>(lhs: T, rhs: T?) -> Bool { return lhs >=? rhs ?? false }

/// Returns lhs! < rhs, otherwise false
public func < <T: Comparable>(lhs: T?, rhs: T) -> Bool { return lhs <? rhs ?? false }

/// Returns lhs! <= rhs, otherwise false
public func <= <T: Comparable>(lhs: T?, rhs: T) -> Bool { return lhs <=? rhs ?? false }

/// Returns lhs! == rhs, otherwise false
public func == <T: Comparable>(lhs: T?, rhs: T) -> Bool { return lhs ==? rhs ?? false }

/// Returns lhs! > rhs, otherwise false
public func > <T: Comparable>(lhs: T?, rhs: T) -> Bool { return lhs >? rhs ?? false }

/// Returns lhs! >= rhs, otherwise false
public func >= <T: Comparable>(lhs: T?, rhs: T) -> Bool { return lhs >=? rhs ?? false }
