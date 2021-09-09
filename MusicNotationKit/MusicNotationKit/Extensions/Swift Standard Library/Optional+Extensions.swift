import Foundation

extension Optional where Wrapped: Numeric {
    
    func orZero() -> Wrapped {
        return self ?? 0
    }
    
    func orOne() -> Wrapped {
        return self ?? 1
    }
}
