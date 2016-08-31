import Cocoa
import Foundation

/*
 There is no problem so big so strong so bad that it cannot be solved with a surfeit of print statements
 */

//-----------------------------------------------------------------------------
// MARK: Pass-through Postfix Printing
//-----------------------------------------------------------------------------

postfix operator *?

/// Postfix printing for quick playground tests
public postfix func *?<T>(object: T) -> T {
    return print(object)
}

postfix operator **?

/// DEBUG-only postfix printing
public postfix func **? <T>(object: T) -> T {
    #if DEBUG
        print(object)
    #endif
    return object
}

postfix operator *?!

/// Postfix printing for quick playground tests
public postfix func *?!<T>(object: T) -> T {
    return dump(object)
}

postfix operator **?!

/// DEBUG-only postfix printing
public postfix func **?! <T>(object: T) -> T {
    #if DEBUG
        dump(object)
    #endif
    return object
}

//-----------------------------------------------------------------------------
// MARK: Diagnostic Output
//-----------------------------------------------------------------------------

/// Shows the current source file and line
/// Follow with ?* or ?*! to print/dump the item being looked at
/// ```
/// guard
///    here() ?* !histogram.isEmpty,
///    let image = here() ?* BarChart(numbers: histogram)
/// ```
/// alternatively, stick at the end of lines to see where
/// evaluation stops
/// ```
/// if
///    let json = try JSONSerialization
///        .jsonObject(with: data, options: []) as? NSDictionary, here("JSON"),
///    let resultsList = json["results"] as? NSArray, here("resultsList")
/// ```
func here(_ note: String = "", file: String = #file, line: Int = #line) -> Bool {
    let filename = (file as NSString).lastPathComponent
    if note.isEmpty { print("[\(filename):\(line)] ") }
    else { print("[\(filename):\(line) \(note)] ") }
    return true
}

/// Diagnoses object state in compound conditions.
/// Always returns true, so it does not interfere with
/// the condition progression.
///
/// - Parameter object: Will print any non-nil object
/// - Parameter note: (optional)
/// ```
/// if
///    let json = try JSONSerialization
///        .jsonObject(with: data, options: []) as? NSDictionary, diagnose(json),
///    let resultsList = json["results"] as? NSArray, diagnose(resultsList),
/// ```
func diagnose<T>(
    _ object: T?, note: String = "",
    file: String = #file, line: Int = #line) -> Bool
{
    let filename = (file as NSString).lastPathComponent
    print("[\(filename):\(line)] ", terminator: "")
    
    if !note.isEmpty { print(note) }
    else { print ("*") }
    
    if let object = object { print(object) }
    
    return true
}

//-----------------------------------------------------------------------------
// MARK: Diagnostic Infix Printing
//-----------------------------------------------------------------------------

precedencegroup VeryLowPrecedence {
    associativity: right
    lowerThan: AssignmentPrecedence
}

/// An operator alternative to diagnose, which can be a pain to type.
/// These use a low precedence infix operator to allow the entire
/// condition to be evaluated and printed before assignment.
/// Place the argument and operator inline before the condition.
/// ```
/// guard let x = here() ?* complex condition statement, ...
/// ```
/// Using here() as the first argument prints the location
/// in code before peforming the dump or print


infix operator ?* : VeryLowPrecedence
infix operator ?*! : VeryLowPrecedence

/// Quick print the following item. Infix operator
/// so this requires some value (typically `here()`)
/// to follow onto. If you don't want to print a location,
/// you can put any dummy value before the ?*.
func ?*<T>(_: Any, item: T) -> T {
    print(item); return item
}

/// Fully dump the following item. Infix operator
/// so this requires some value (typically `here()`)
/// to follow onto. If you don't want to print a location,
/// you can put any dummy value before the ?*.
func ?*! <T>(_: Any, item: T) -> T {
    dump(item); return item
}


