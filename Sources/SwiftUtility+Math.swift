// --------------------------------------------------
// MARK: - EXPONENTIATION
// --------------------------------------------------

import Foundation

/// Exponentiation operator
infix operator **

extension SignedInteger {
    /// Returns base ^^ exp
    /// - parameter base: the base value
    /// - parameter exp: the exponentiation value
    static func **(base: Self, exp: Int) -> Self {
        return repeatElement(base, count: exp).reduce(1 as! Self, *)
    }
}

extension FloatingPoint {
    /// Returns base ^^ exp
    /// - parameter base: the base value
    /// - parameter exp: the exponentiation value
    static func **(base: Self, exp: Int) -> Self {
        return repeatElement(base, count: exp).reduce(1, *)
    }
}

extension Double {
    /// Returns base ^^ exp
    /// - parameter base: the base value
    /// - parameter exp: the exponentiation value
    static func **(base: Double, exp: Double) -> Double {
        return pow(base, exp)
    }
    
    /// Returns base ^^ exp
    /// - parameter base: the base value
    /// - parameter exp: the exponentiation value
    static func **(base: Int, exp: Double) -> Double {
        return pow(Double(base), exp)
    }
}

// --------------------------------------------------
// MARK: - Double Conversion
// --------------------------------------------------

extension BinaryFloatingPoint {
    public var doubleValue: Double {
        guard !(self is Double) else { return self as! Double }
        guard !(self is Float) else { return Double(self as! Float) }
        guard !(self is Float80) else { return Double(self as! Float80) }
        guard !(self is CGFloat) else { return Double(self as! CGFloat) }
        fatalError("Unsupported floating point type")
    }
    
    public var intValue: Int { return lrint(self.doubleValue) }
}


