import Foundation

struct ElementPopper<T> {
    var index = 0
    let array: [T]
    
    init(array: [T]) {
        self.array = array
    }
    
    func next() -> T? {
        if index < array.count {
            let item = array[index]
            return item
        } else {
            return nil
        }
    }
    
    @discardableResult mutating func popNext() -> T? {
        if index < array.count {
            let item = array[index]
            index += 1
            return item
        } else {
            return nil
        }
    }
}
