import Foundation

extension Array where Element: Numeric {
    
    func sum() -> Element {
        return self.reduce(0, +)
    }
}
