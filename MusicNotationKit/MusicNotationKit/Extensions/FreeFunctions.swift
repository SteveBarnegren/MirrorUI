import Foundation

public func repeated(times: Int, handler: () -> Void) {
    if times <= 0 {
        return
    }
    
    for _ in (0..<times) {
        handler()
    }
}
