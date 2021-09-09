import Foundation

extension Int {
    
    enum RoundingPolicy {
        case up
        case down
    }
    
    func nearestEven(rounding: RoundingPolicy) -> Int {
        
        if self.isEven {
            return self
        }
        
        switch rounding {
        case .up:
            return self + 1
        case .down:
            return self - 1
        }
    }
    
    func nearestOdd(rounding: RoundingPolicy) -> Int {
        
        if self.isOdd {
            return self
        }
        
        switch rounding {
        case .up:
            return self + 1
        case .down:
            return self - 1
        }
    }
}
