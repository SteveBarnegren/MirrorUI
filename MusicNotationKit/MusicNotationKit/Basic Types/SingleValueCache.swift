import Foundation

public class SingleValueCache<T> {
    
    private let getValue: () -> T
    private var cachedValue: T?
        
    public init(calculate: @escaping () -> (T)) {
        self.getValue = calculate
    }
    
    public var value: T {
        if let existingValue = cachedValue {
            return existingValue
        } else {
            let value = getValue()
            cachedValue = value
            return value
        }
    }
    
    func invalidate() {
        cachedValue = nil
    }
}
