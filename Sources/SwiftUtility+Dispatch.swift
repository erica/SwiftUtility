import Foundation

/// Executes closure on global queue (not main) after a delay in seconds
public func perform(after delay: Double, _ action: @escaping () -> Void) {
    DispatchQueue
        .global(qos: .default)
        .asyncAfter(deadline:  .now() + delay, execute: action)
}

/// Executes closure on global queue (not main) after a delay
public func perform(after delay: DispatchTimeInterval, _ action: @escaping () -> Void) {
    DispatchQueue
        .global(qos: .default)
        .asyncAfter(deadline: .now() + delay, execute: action)
}

/// Executes closure on main queue after a delay in seconds
public func performOnMain(after delay: Double, _ action: @escaping () -> Void) {
    DispatchQueue
        .main
        .asyncAfter(deadline:  .now() + delay, execute: action)
}

/// Executes closure on main queue after a delay
public func performOnMain(after delay: DispatchTimeInterval, _ action: @escaping () -> Void) {
    DispatchQueue
        .main
        .asyncAfter(deadline: .now() + delay, execute: action)
}
