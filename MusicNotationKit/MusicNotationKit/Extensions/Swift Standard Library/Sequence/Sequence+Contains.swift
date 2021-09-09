import Foundation

extension Sequence where Element: Equatable {
    
    func contains<T: Sequence>(anyOf other: T) -> Bool where T.Element == Element {
        return self.contains { (element) -> Bool in
            other.contains(element)
        }
    }
}
