import Foundation

public class Lazy<T> {
    
    private indirect enum State<T> {
        case closure( () -> (T) )
        case value(T)
    }
    
    private var state: State<T>
    
    public init(calculate: @escaping () -> (T)) {
        self.state = .closure(calculate)
    }
    
    public var value: T {
        switch state {
        case .value(let value):
            return value
        case .closure(let closure):
            let result = closure()
            self.state = .value(result)
            return result
        }
    }
}
