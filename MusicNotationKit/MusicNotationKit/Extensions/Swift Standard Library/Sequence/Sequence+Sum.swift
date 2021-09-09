import Foundation

extension Sequence {
    
    public func sum<T: Numeric>(of transform: (Element) -> T) -> T {
        return self.reduce(0, { $0 + transform($1) })
    }
    
    public func sum<T: Numeric>(_ keyPath: KeyPath<Element, T>) -> T {
        return self.reduce(0, { $0 + $1[keyPath: keyPath] })
    }
}
