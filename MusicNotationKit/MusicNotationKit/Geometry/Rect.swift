import Foundation

struct Rect {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
    
    static let zero = Rect(x: 0, y: 0, width: 0, height: 0)
    
    var maxX: Double {
        x + width
    }
    
    var minX: Double {
        return x
    }
    
    var midX: Double {
        return (minX + maxX)/2
    }
    
    var maxY: Double {
        y + height
    }
    
    var minY: Double {
        return y
    }
    
    var midY: Double {
        return (minY + maxY)/2
    }
    
    var origin: Vector2D {
        return Vector2D(x, y)
    }
    
    var bottomLeft: Vector2D {
        return Vector2D(x, y)
    }
    
    var bottomRight: Vector2D {
        return Vector2D(x + width, y)
    }
    
    var topLeft: Vector2D {
        return Vector2D(x, y + height)
    }
    
    var topRight: Vector2D {
        return Vector2D(x + width, y + height)
    }
    
    var center: Vector2D {
        return Vector2D(x + width/2, y + height/2)
    }
    
    func adding(height: Double) -> Rect {
        var copy = self
        copy.height += height
        return copy
    }
    
    func subtracting(height: Double) -> Rect {
        var copy = self
        copy.height -= height
        return copy
    }
 }

// MARK: - Convinience init

extension Rect {
    
    init(origin: Vector2D, size: Vector2D) {
        self.x = origin.x
        self.y = origin.y
        self.width = size.width
        self.height = size.height
    }
}

// MARK: - Translate

extension Rect {
    
    func translated(x: Double, y: Double) -> Rect {
        return Rect(x: self.x + x, y: self.y + y, width: width, height: height)
    }
}
