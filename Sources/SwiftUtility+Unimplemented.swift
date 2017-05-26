// --------------------------------------------------
// MARK: Unimplemented functionality
// --------------------------------------------------

/// Handles unimplemented functionality with site-specific information, courtesy of Sourosh Khanlou
func unimplemented(_ function: String = #function, _ file: String = #file) -> Never {
    fatalError("\(function) in \(file) has not been implemented")
}

