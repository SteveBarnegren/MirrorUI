import Foundation

public extension Array {
    
    mutating func append(maybe item: Element?) {
        
        if let item = item {
            append(item)
        }
    }
    
    func appending(maybe item: Element?) -> [Element] {
        
        if let item = item {
            return appending(item)
        } else {
            return self
        }
    }
}
