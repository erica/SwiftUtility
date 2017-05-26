import Foundation

//-----------------------------------------------------------------------------
// MARK: Time Test
//-----------------------------------------------------------------------------

/// Prints the elapsed time to execute a block under whatever optimization
/// conditions are currently in use by the compiler
public func timetest(_ note: String, block: () -> Void) {
    print("Starting Test:", note)
    let now = ProcessInfo().systemUptime
    block()
    let timeInterval = ProcessInfo().systemUptime - now
    print("Ending Test:", note); print("Elapsed time: \(timeInterval)")
}
