//-----------------------------------------------------------------------------
// MARK: Precedence
//-----------------------------------------------------------------------------


//  BitwiseShiftPrecedence > MultiplicationPrecedence > AdditionPrecedence > RangeFormationPrecedence > CastingPrecedence > NilCoalescingPrecedence > ComparisonPrecedence > LogicalConjunctionPrecedence > LogicalDisjunctionPrecedence > TernaryPrecedence > AssignmentPrecedence > FunctionArrowPrecedence > [nothing]
//  DefaultPrecedence > TernaryPrecedence

/// Low precedence group
precedencegroup LowPrecedence { higherThan: VeryLowPrecedence }

/// Very low precedence group
precedencegroup VeryLowPrecedence { lowerThan: FunctionArrowPrecedence }

/// Very high precedence
precedencegroup VeryHighPrecedence { higherThan:  HighPrecedence}

/// High precedence
precedencegroup HighPrecedence { higherThan: BitwiseShiftPrecedence }

/// Left associative precedence
precedencegroup LeftAssociativePrecedence { associativity: left }
