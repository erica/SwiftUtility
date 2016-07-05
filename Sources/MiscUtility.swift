import Foundation

public func timetest(_ note: String, block: () -> Void) {
    let date = Date()
    block()
    let timeInterval = Date().timeIntervalSince(date)
    print("Test:", note); print("Elapsed time: \(timeInterval)")
}

