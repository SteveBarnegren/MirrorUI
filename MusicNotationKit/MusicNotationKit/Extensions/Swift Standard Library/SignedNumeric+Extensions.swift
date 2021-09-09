import Foundation

extension SignedNumeric {

    func inverted(if inverted: Bool) -> Self {
        if inverted {
            return -self
        } else {
            return self
        }
    }
    
    func inverted(if expression: () -> Bool) -> Self {
        if expression() == true {
            return -self
        } else {
            return self
        }
    }
}
