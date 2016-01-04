/*

Erica Sadun, http://ericasadun.com
Basic Errors

*/

/// Workaround to avoid using Foundation for lastPathComponent
private func trimString(string: String, toBoundary boundary: Character) -> String {
    if string.isEmpty { return "" }
    var limitIndex = string.endIndex.predecessor()
    while limitIndex >= string.startIndex {
        if string.characters[limitIndex] == boundary {
            return string[limitIndex.successor()..<string.endIndex]
        }
        if limitIndex == string.startIndex { break }
        limitIndex = limitIndex.predecessor()
    }
    return string
}

/// A basic utility error type that stores the reason for
/// a failed operation and the context under which the error
/// has occurred
public struct CoreError: ErrorType {
    
    let (reason, context): (String, String)
    
    public init(
        _ reason: String,
        _ context: String = __FILE__)
    {
        
        (self.reason, self.context) = (reason, context)
    }
}

/// By adopting Contextualizable, constructs can build errors
/// specific to their calling conditions
public protocol Contextualizable {}

/// Adding default implementation for error building
public extension Contextualizable {
    
    /// Creates a context error at the point of failure, picking
    /// up the file, function, and line of the error event
    public func BuildContextError(
        items: Any...,
        file: String = trimString(__FILE__, toBoundary: "/"),
        function: String = __FUNCTION__,
        line: Int = __LINE__
        ) -> CoreError
    {
        
        let reasons = items.map({ "\($0)" }).joinWithSeparator(", ")
        let context = "\(function):\(self.dynamicType):\(file):\(line) "
        
        return CoreError(reasons, context)
    }
}

/// A lighter weight alternative to Contextualizable that still
/// picks up file and line context for error handling
///
/// - param items: Caller can supply zero or more instances as "reasons", which
///   need not be strings. Their default representation will be added
///   to the 'reasons' list.
public func ContextError(
    items: Any...,
    file: String = trimString(__FILE__, toBoundary: "/"),
    line: Int = __LINE__
    ) -> CoreError
{
    let reasons = items.map({ "\($0)" }).joinWithSeparator(", ")
    let context = "\(file):\(line) "
    return CoreError(reasons, context)
}

/// Replacement for `try?` that introduces printing for
/// error conditions instead of discarding those errors
///
/// - Parameter shouldCrash: defaults to false. When set to true
///   will raise a fatal error, emulating try! instead of try?
///
/// ```swift
/// attempt {
///   let mgr = NSFileManager.defaultManager()
///   try mgr.createDirectoryAtPath(
///     "/Users/notarealuser",
///     withIntermediateDirectories: true,
///     attributes: nil)
/// }
///
public func attempt<T>(
    line line: Int = __LINE__,
    shouldCrash: Bool = false,
    closure: () throws -> T
    ) -> T?
{
    do {
        
        /// Return executes only if closure succeeds
        return try closure()
        
    } catch {
        
        /// Emulate try! by crashing
        if shouldCrash {
            print("Fatal error on line \(line): \(error)")
            fatalError()
        }
        
        /// Force print and return nil like try?
        print("Error \(line): \(error)")
        return nil
    }
}

/// Alternative to attempt that ignores any results and returns
/// a Boolean value indicating success
public func testAttempt<T>(
    line line: Int = __LINE__,
    shouldCrash: Bool = false,
    closure: () throws -> T
    ) -> Bool
{
    /// Throw away result but check for non-nil. Thanks nuclearace
    return attempt(
        line: line,
        shouldCrash: shouldCrash,
        closure: closure
        ) == nil ? false : true
}