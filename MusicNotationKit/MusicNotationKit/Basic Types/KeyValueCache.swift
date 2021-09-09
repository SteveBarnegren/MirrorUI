import Foundation

class KeyValueCache<Key: Hashable, Value> {
    
    // MARK: - Types
    
    private class KeyWrapper: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int {
            return key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            if let other = object as? KeyWrapper {
                return key == other.key
            } else {
                return false
            }
        }
    }
    
    private class ValueWrapper: NSObject {
        let value: Value
        
        init(_ value: Value) {
            self.value = value
        }
    }
    
    // MARK: - Properties
    
    private let nsCache = NSCache<KeyWrapper, ValueWrapper>()
    
    // MARK: - Add / Remove
    
    func set(value: Value, forKey key: Key) {
        let wrappedKey = KeyWrapper(key)
        let wrappedValue = ValueWrapper(value)
        
        nsCache.setObject(wrappedValue, forKey: wrappedKey)
    }
    
    func value(forKey key: Key) -> Value? {
        let wrappedKey = KeyWrapper(key)
        return nsCache.object(forKey: wrappedKey)?.value
    }
}
