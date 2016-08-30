/// Evaluates the given closure when two `Optional` instances are not `nil`,
/// passing the unwrapped values as parameters. (Thanks, Mike Ash)
fileprivate func _flatMap2<T, U, V>(_ first: T?, _ second: U?, _ transform: (T, U) throws -> V?) rethrows -> V? {
    return try first.flatMap({ f in
        try second.flatMap({ s in
            try transform(f, s) })})
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

/// Returns lhs! < rhs!, otherwise nil
public func<? <T: Comparable>(lhs: T?, rhs: T?) -> Bool? { return _flatMap2(lhs, rhs, <) }

/// Returns lhs! <= rhs!, otherwise nil
public func<=? <T: Comparable>(lhs: T?, rhs: T?) -> Bool? { return _flatMap2(lhs, rhs, <=) }

/// Returns lhs! == rhs!, otherwise nil
public func==? <T: Comparable>(lhs: T?, rhs: T?) -> Bool? { return _flatMap2(lhs, rhs, ==) }

/// Returns lhs! > rhs!, otherwise nil
public func>? <T: Comparable>(lhs: T?, rhs: T?) -> Bool? { return _flatMap2(lhs, rhs, >) }

/// Returns lhs! >= rhs!, otherwise nil
public func>=? <T: Comparable>(lhs: T?, rhs: T?) -> Bool? { return _flatMap2(lhs, rhs, >=) }

// MARK: Unwrapped Optional Comparisons
// Following the example of IEEE754 with NAN, any comparison involving
// .None is false (Thanks, Mike Ash)

/// Returns lhs! < rhs!, otherwise false
public func< <T: Comparable>(lhs: T?, rhs: T?) -> Bool { return lhs <? rhs ?? false }

/// Returns lhs! <= rhs!, otherwise false
public func<= <T: Comparable>(lhs: T?, rhs: T?) -> Bool { return lhs <=? rhs ?? false }

/// Returns lhs! == rhs!, otherwise false
public func== <T: Comparable>(lhs: T?, rhs: T?) -> Bool { return lhs ==? rhs ?? false }

/// Returns lhs! > rhs!, otherwise false
public func> <T: Comparable>(lhs: T?, rhs: T?) -> Bool { return lhs >? rhs ?? false }

/// Returns lhs! >= rhs!, otherwise false
public func>= <T: Comparable>(lhs: T?, rhs: T?) -> Bool { return lhs >=? rhs ?? false }

