/*
 
 Erica Sadun, http://ericasadun.com
 Basic Errors
 
 */

import Foundation

/*
 
 Note: Consider introducing autoclosures?
 
 */

/// A basic utility error type. It stores a reason for
/// a failed operation and the context under which the error
/// has occurred
public struct CoreError: ErrorType {
    
    let (reason, context): (String, String)
    
    public init(
        _ reason: String,
          _ context: String = "",
            fileName: String = #file,
            lineNumber: Int = #line
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
        fileName: String = #file,
        function: String = #function,
        line: Int = #line
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
    fileName: String = #file,
    lineNumber: Int = #line
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

/// consists of file path, line number, error tuple
public typealias CommonErrorHandlerType = (String, Int, ErrorType) -> Void

/// Default error handler prints context and error
public let defaultCommonErrorHandler: CommonErrorHandlerType = {
    filePath, lineNumber, error in
    let trimmedFileName: String = (filePath as NSString).lastPathComponent
    print("Error \(trimmedFileName):\(lineNumber) \(error)")
}

/// Replacement for `try?` that introduces an error handler
/// The default error handler prints an error before returning nil
///
/// - Parameter file: source file, derived from `__FILE__` context literal
/// - Parameter line: source line, derived from `__LINE__` context literal
/// - Parameter crashOnError: defaults to false. When set to true
///   will raise a fatal error, emulating try! instead of try?
/// - Parameter errorHandler: processes the error, returns nil
///
/// ```swift
/// // Void example, will fail
/// attempt {
///   let mgr = NSFileManager.defaultManager()
///   try mgr.createDirectoryAtPath(
///     "/Users/notarealuser",
///     withIntermediateDirectories: true,
///     attributes: nil)
/// }
///
/// // Return example, will fail
/// let x = attempt {
///     _ -> [NSURL] in
///     let url = NSURL(fileURLWithPath: "/Not/Real")
///     return try NSFileManager
///         .defaultManager()
///         .contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: [])
/// }
///
/// /// Return example, will succeed
/// let y = attempt {
///     _ -> [NSURL] in
///     let url = NSBundle.mainBundle().bundleURL
///     return try NSFileManager
///         .defaultManager()
///         .contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: [])
/// }
/// ```
///
public func attempt<T>(
    file fileName: String = #file,
         line lineNumber: Int = #line,
              crashOnError: Bool = false,
              errorHandler: CommonErrorHandlerType = defaultCommonErrorHandler,
              @noescape closure: () throws -> T) -> T? {
    
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
    file fileName: String = #file,
         line lineNumber: Int = #line,
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