import Foundation

extension Array where Element == Path.Command {
    
    // TODO: Use proper bezier curve measuring
    func width() -> Double {
        
        var minX = 0.0
        var maxX = 0.0
        
        func process(_ p: Vector2D) {
            minX = Swift.min(minX, p.x)
            maxX = Swift.max(maxX, p.x)
        }
        
        for command in self {
            switch command {
                case .move(let p):
                    process(p)
                case .line(let p):
                    process(p)
                case .quadCurve(let p, _):
                    process(p)
                case .curve(let p, _, _):
                    process(p)
                case .close:
                    break
                case .circle(let p, let r):
                    minX = Swift.min(minX, p.x - r)
                    maxX = Swift.max(maxX, p.x + r)
                case .arc(center: _, radius: _, startAngle: _, endAngle: _, clockwise: _):
                    break
            }
        }
        
        return maxX - minX
    }
}
