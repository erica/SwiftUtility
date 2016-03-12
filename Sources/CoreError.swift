/*

    Erica Sadun, http://ericasadun.com
    Basic Errors

*/

import Foundation

/*

    This code continues to use old-style context identifiers.
    This is easily migrated.

    __FILE__ -> #file String
    __LINE__ -> #line Int
    __COLUMN__ -> #column Int
    __FUNCTION__ -> #function String (should be Selector?)

    See: https://github.com/apple/swift-evolution/blob/master/proposals/0028-modernizing-debug-identifiers.md

    Requesting #fileName to specify the last path
    component for what is currently #file

*/

/// A basic utility error type. It stores a reason for
/// a failed operation and the context under which the error
/// has occurred
public struct CoreError: ErrorType {
    
    let (reason, context): (String, String)
    
    public init(
        _ reason: String,
        _ context: String = "",
        fileName: String = __FILE__,
        lineNumber: Int = __LINE__
        )
    {
        /// Establishes a context if one is not supplied by the caller
        let derivedContext = context.isEmpty
            ? (fileName as NSString).lastPathComponent + ":\(lineNumber)"
            : context
        
        // Initialize with supplied reason and derived or supplied context
        (self.reason, self.context) = (reason, derivedContext)
    }
}

/// On adopting Contextualizable, constructs can build errors
/// specific to their calling conditions
public protocol Contextualizable {}

// Introduces a default implementation to support context-dependent
// error building
public extension Contextualizable {
    
    /// Creates a context error at the point of failure, picking
    /// up the file, function, and line of the error event
    public func BuildContextError(
        items: Any...,
        fileName: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__
        ) -> CoreError
    {
        /// Caller supplies one or more instances
        /// as "reasons", which need not be strings. Their default
        /// representation will be added to the 'reasons' list.
        let reasons = items.map({ "\($0)" }).joinWithSeparator(", ")
        
        /// Trimmed file name, derived from calling context
        let coreFileName = (fileName as NSString).lastPathComponent
        
        /// Calling context composed of function, type, file name, line
        let context = "\(function):\(self.dynamicType):\(coreFileName):\(line) "
        
        // Produce and return a core error
        return CoreError(reasons, context)
    }
}

/// A lighter weight alternative to Contextualizable that also
/// picks up file and line context for error handling
///
/// - parameter items: Caller supplies one or more instances
///   as "reasons", which need not be strings. Their default
///   representation will be added to the 'reasons' list.
public func ContextError(
    items: Any...,
    fileName: String = __FILE__,
    lineNumber: Int = __LINE__
    ) -> CoreError
{
    /// Munges supplied items into a single compound "reason"
    /// describing the reasons the error took place
    let reasons = items.map({ "\($0)" }).joinWithSeparator(", ")
    
    /// Trimmed file name, derived from calling context
    let coreFileName = (fileName as NSString).lastPathComponent
    
    /// Establish the context
    let context = "\(coreFileName):\(lineNumber) "
    
    // Produce and return a core error
    return CoreError(reasons, context)
}

public typealias CommonErrorHandlerType = (String, Int, ErrorType) -> Void

/// Replacement for `try?` that introduces an error handler
/// The default handler prints an error before returning nil
///
/// - Parameter file: source file, derived from `__FILE__` context literal
/// - Parameter line: source line, derived from `__LINE__` context literal
/// - Parameter crashOnError: defaults to false. When set to true
///   will raise a fatal error, emulating try! instead of try?
/// - Parameter errorHandler: processes the error, returns nil
///
/// ```swift
/// attempt {
///   let mgr = NSFileManager.defaultManager()
///   try mgr.createDirectoryAtPath(
///     "/Users/notarealuser",
///     withIntermediateDirectories: true,
///     attributes: nil)
/// }
/// ```
///
public func attempt<T>(
    file fileName: String = __FILE__,
    line lineNumber: Int = __LINE__,
    crashOnError: Bool = false,
    errorHandler: CommonErrorHandlerType = {
        // Default handler prints context:error and returns nil
        fileName, lineNumber, error in
        
        /// Retrieve last path component because #fileName is
        /// not yet a thing in Swift
        let trimmedFileName: String = (fileName as NSString).lastPathComponent
        
        /// Force print and return nil like try?
        print("Error \(trimmedFileName):\(lineNumber) \(error)")
    },
    closure: () throws -> T) -> T? {
        
        do {
            // Return executes only if closure succeeds, returning T
            return try closure()
            
        } catch {
            // Emulate try! by crashing
            if crashOnError {
                print("Fatal error \(fileName):\(lineNumber): \(error)")
                fatalError()
            }
            
            // Execute error handler and return nil
            errorHandler(fileName, lineNumber, error)
            return nil
        }
}

/// Alternative to attempt that ignores any results and returns
/// a Boolean value indicating success
public func testAttempt<T>(
    file fileName: String = __FILE__,
    line lineNumber: Int = __LINE__,
    crashOnError: Bool = false,
    closure: () throws -> T
    ) -> Bool
{
    /// Throw away result but check for non-nil. Thanks nuclearace
    return attempt(
        file: fileName,
        line: lineNumber,
        crashOnError: crashOnError,
        closure: closure
        ) == nil ? false : true
}