import Foundation

extension Sequence {
    
    func max<T: Comparable>(byKey key: KeyPath<Element, T>) -> Element? {
        return self.max { (first, second) -> Bool in
            return second[keyPath: key] > first[keyPath: key]
        }
    }
    
    func min<T: Comparable>(byKey key: KeyPath<Element, T>) -> Element? {
        return self.min { (first, second) -> Bool in
            return second[keyPath: key] > first[keyPath: key]
        }
    }
    
    func max<T: Comparable>(byTransform transform: (Element) -> T) -> Element? {
        return self.max { (first, second) -> Bool in
            return transform(second) > transform(first)
        }
    }
    
    func min<T: Comparable>(byTransform transform: (Element) -> T) -> Element? {
        return self.min { (first, second) -> Bool in
            return transform(second) > transform(first)
        }
    }
}
