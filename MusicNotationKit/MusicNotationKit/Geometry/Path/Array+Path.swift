import Foundation

extension Array where Element == Path {
    
    var minY: Double {
        return self.map { $0.minY }.min() ?? 0
    }
    
    var maxY: Double {
        return self.map { $0.maxY }.max() ?? 0
    }
}
