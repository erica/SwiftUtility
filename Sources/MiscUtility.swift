import Foundation

public func timetest(block: () -> Void) {
    let date = NSDate()
    block()
    let timeInterval = NSDate().timeIntervalSinceDate(date)
    print("Elapsed time: \(timeInterval)")
}

