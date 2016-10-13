// MARK: Introduction
//
// Better `Optional` comparisons
//
// This implementation provides the following styles of optional comparison:
// 
// Wrapped Optional Comparisons:
//
// * Compare p? and q?, and return p! op q!, otherwise nil
// * Compare p and q?, and return p op q!, otherwise nil
// * Compare p? and q, and return p! op q, otherwise nil
//
// Unwrapped Optional Comparions:
//
// * Compare p? and q?, and return p! op q!, otherwise false
// * Compare p and q?, and return p op q!, otherwise false
// * Compare p? and q, and return p! op q, otherwise false
//
// These implementations follow the precedent of IEEE754 wrt NaN:
// Any comparison involving .none is invalid, producing nil 
// (wrapped result) or false (truth value result)
//
// See also: http://stackoverflow.com/questions/1565164/what-is-the-rationale-for-all-comparisons-returning-false-for-ieee754-nan-values
//
// Thanks, Mike Ash, Tim Vermeulen, Greg Titus, Brent Royal-Gordon
//
// Brent RG offers his take here: https://gist.github.com/brentdax/60460ad4578d5d8d52a9d736240cfea6

// MARK: Utility

/// Evaluates the given closure when two `Optional` instances are not `nil`,
/// passing the unwrapped values as parameters.
fileprivate func _flatMap2<T, U, V>(
    _ first: T?, _ second: U?,
    _ transform: (T, U) throws -> V?) rethrows -> V?
{
    guard let first = first, let second = second else { return nil }
    return try transform(first, second)
}

// MARK: Wrapped Optional Comparisons

/// Weak precedence ensures that comparison happens late
precedencegroup OptionalComparisonPrecedence {
    higherThan: NilCoalescingPrecedence
}

/// Failable less-than comparison
infix operator <?: OptionalComparisonPrecedence

/// Failable less-than-or-equal comparison
infix operator <=?: OptionalComparisonPrecedence

/// Failable equality comparison
infix operator ==?: OptionalComparisonPrecedence

/// Failable greater-than comparison
infix operator >?: OptionalComparisonPrecedence

/// Failable greater-than-or-equal comparison
infix operator >=?: OptionalComparisonPrecedence

// MARK: Wrapped Optional Comparisons

// These operators compare two optional truth values p? and q?
// returning `p op q` for non-nil values, otherwise nil

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

// These operators compare an optional truth value p? and
// a non-optional truth value q, returning `p op q` for non-nil 
// p?, otherwise nil

/// Returns lhs! < rhs, otherwise nil
public func <? <T: Comparable>(lhs: T?, rhs: T) -> Bool? { return lhs.map({ $0 < rhs }) }

/// Returns lhs! <= rhs, otherwise nil
public func <=? <T: Comparable>(lhs: T?, rhs: T) -> Bool? { return lhs.map({ $0 <= rhs }) }

/// Returns lhs! == rhs, otherwise nil
public func ==? <T: Comparable>(lhs: T?, rhs: T) -> Bool? { return lhs.map({ $0 == rhs }) }

/// Returns lhs! > rhs, otherwise nil
public func >? <T: Comparable>(lhs: T?, rhs: T) -> Bool? { return lhs.map({ $0 > rhs }) }

/// Returns lhs! >= rhs, otherwise nil
public func >=? <T: Comparable>(lhs: T?, rhs: T) -> Bool? { return lhs.map({ $0 >= rhs }) }

// These operators compare a non-optional truth value q and
// an optional truth value q?, returning `p op q` for non-nil
// q?, otherwise nil

/// Returns lhs < rhs!, otherwise nil
public func <? <T: Comparable>(lhs: T, rhs: T?) -> Bool? { return rhs.map({ lhs < $0 }) }

/// Returns lhs <= rhs!, otherwise nil
public func <=? <T: Comparable>(lhs: T, rhs: T?) -> Bool? { return rhs.map({ lhs <= $0 }) }

/// Returns lhs == rhs!, otherwise nil
public func ==? <T: Comparable>(lhs: T, rhs: T?) -> Bool? { return rhs.map({ lhs == $0 }) }

/// Returns lhs > rhs!, otherwise nil
public func >? <T: Comparable>(lhs: T, rhs: T?) -> Bool? { return rhs.map({ lhs > $0 }) }

/// Returns lhs >= rhs!, otherwise nil
public func >=? <T: Comparable>(lhs: T, rhs: T?) -> Bool? { return rhs.map({ lhs >= $0 }) }

// MARK: Unwrapped Optional Comparisons

// These operators compare two optional truth values p? and q?
// returning `p op q` for non-nil values, otherwise false

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

// These operators compare an optional truth value p? and
// a non-optional truth value q, returning `p op q` for non-nil
// p?, otherwise false

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

// These operators compare a non-optional truth value q and
// an optional truth value q?, returning `p op q` for non-nil
// q?, otherwise false

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

