import Foundation

extension CharacterSet {
    /// Returns member count
    public var count: Int {
        var count = 0
        for i in 0 ..< 8192 * 16 {
            if
                let scalar = UnicodeScalar(i),
                contains(scalar) {
                count = count + 1
            }
        }
        return count
    }
    
    /// Returns set of members, presented as strings
    public var members: Set<String> {
        var set: Set<String> = []
        for i in 0 ..< 8192 * 16 {
            if
                let scalar = UnicodeScalar(i),
                contains(scalar) {
                set.insert(String(scalar))
            }
        }
        return set
    }
}

