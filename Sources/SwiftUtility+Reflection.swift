//-----------------------------------------------------------------------------
// MARK: Default class reflection
//
// Thanks, Mike Ash
//-----------------------------------------------------------------------------

/// Provides a better default representation for reference types than the class name
public protocol DefaultReflectable: CustomStringConvertible {}

/// A default implementation to enable class members to display their values
extension DefaultReflectable {
    
    /// Constructs a better representation using reflection
    internal func DefaultDescription<T>(instance: T) -> String {
        
        let mirror = Mirror(reflecting: instance)
        let chunks = mirror.children.map({
            (child) -> String in
            guard let label = child.label else { return "\(child.value)" }
            return child.value is String ?
                "\(label): \"\(child.value)\"" : "\(label): \(child.value)"
        })
        
        if chunks.isEmpty { return "\(instance)" }
        let chunksString = chunks.joined(separator: ", ")
        return "\(mirror.subjectType)(\(chunksString))"
    }
    
    /// Conforms to CustomStringConvertible
    public var description: String { return DefaultDescription(instance: self) }
}


