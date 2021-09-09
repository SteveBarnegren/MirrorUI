import Foundation

public extension Collection where Index == Int {
    
    subscript(maybe index: Int) -> Element? {
        
        if index > count - 1 {
            return nil
        } else if index < 0 {
            return nil
        } else {
            return self[index]
        }
    }
}
