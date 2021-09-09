import Foundation

struct Path {
    
    enum Command: Equatable {
        case move(Vector2D)
        case line(Vector2D)
        case quadCurve(Vector2D, c1: Vector2D)
        case curve(Vector2D, c1: Vector2D, c2: Vector2D)
        case close
        case circle(Vector2D, Double) // Center, Radius
        case arc(center: Vector2D, radius: Double, startAngle: Double, endAngle: Double, clockwise: Bool)
    }
    
    enum DrawStyle {
        case stroke
        case fill
    }
    
    var commands = [Command]()
    var drawStyle = DrawStyle.stroke
    private(set) var boundingBox = Rect.zero
    
    init(commands: [Command] = []) {
        #if DEBUG
        if commands.containsInvalidValues() {
            dump(commands)
            fatalError("Commands contain invalid values. (Nan or Infinite)")
        }
        #endif
        
        self.commands = commands
        boundingBox = self.calculateBoundingBox()
    }
    
    init(rect: Rect) {
        
        let commands: [Command] = [
            .move(rect.bottomLeft),
            .line(rect.topLeft),
            .line(rect.topRight),
            .line(rect.bottomRight),
            .close
        ]
        
        self.init(commands: commands)
    }
    
    init(circleWithCenter center: Vector2D, radius: Double) {
        let command = Path.Command.circle(center, radius)
        self.init(commands: [command])
    }
}

extension Path {
    
    // MARK: - Translate

    mutating func translate(v: Vector2D) {
        self.translate(x: v.x, y: v.y)
    }

    func translated(_ v: Vector2D) -> Path {
        return self.translated(x: v.x, y: v.y)
    }
    
    mutating func translate(x xOffset: Double, y yOffset: Double) {
        commands = commands.translated(x: xOffset, y: yOffset)
        boundingBox = boundingBox.translated(x: xOffset, y: yOffset)
    }
    
    func translated(x: Double, y: Double) -> Path {
        
        var copy = self
        copy.translate(x: x, y: y)
        return copy
    }
    
    // MARK: - Scale
    
    mutating func scale(_ scale: Double) {
   
        commands = commands.scaled(scale)
        boundingBox = Rect(x: boundingBox.x * scale,
                           y: boundingBox.y * scale,
                           width: boundingBox.width * scale,
                           height: boundingBox.height * scale)
    }
    
    func scaled(_ scale: Double) -> Path {
        
        var copy = self
        copy.scale(scale)
        return copy
    }
    
    // MARK: - Flip Y
    
    mutating func invertY() {
        self.commands = commands.invertedY()
        boundingBox = Rect(x: boundingBox.x,
                           y: -boundingBox.y - boundingBox.height,
                           width: boundingBox.width,
                           height: boundingBox.height)
    }
    
    func invertedY() -> Path {
        var copy = self
        copy.invertY()
        return copy
    }
}

extension Array where Element == Path.Command {
    
    func scaled(_ scale: Double) -> [Path.Command] {
        
        if scale == 1 {
            return self
        }
        
        func scalePoint(_ p: Vector2D) -> Vector2D {
            return Vector2D(p.x * scale, p.y * scale)
        }
        
        func scaleSize(_ s: Size) -> Size {
            return Size(width: s.width * scale, height: s.height * scale)
        }
        
        var newCommands = [Path.Command]()
        
        for command in self {
            switch command {
            case .move(let p):
                newCommands.append(.move(scalePoint(p)))
            case .line(let p):
                newCommands.append(.line(scalePoint(p)))
            case .quadCurve(let p, let c1):
                newCommands.append(.quadCurve(scalePoint(p), c1: scalePoint(c1)))
            case .curve(let p, let c1, let c2):
                newCommands.append(.curve(scalePoint(p), c1: scalePoint(c1), c2: scalePoint(c2)))
            case .close:
                newCommands.append(.close)
            case .circle(let p, let r):
                newCommands.append(.circle(scalePoint(p), r * scale))
            case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                newCommands.append(
                    .arc(center: scalePoint(center),
                         radius: radius*scale,
                         startAngle: startAngle,
                         endAngle: endAngle,
                         clockwise: clockwise)
                )
            }
        }
        
        return newCommands
    }

    func translated(_ v: Vector2D) -> [Path.Command] {
        return self.translated(x: v.x, y: v.y)
    }
    
    func translated(x: Double, y: Double) -> [Path.Command] {
        
        if x == 0 && y == 0 {
            return self
        }
        
        var newCommands = [Path.Command]()
        
        func translatePoint(_ p: Vector2D) -> Vector2D {
            return Vector2D(p.x + x, p.y + y)
        }
        
        for command in self {
            switch command {
            case .move(let p):
                newCommands.append(.move(translatePoint(p)))
            case .line(let p):
                newCommands.append(.line(translatePoint(p)))
            case .quadCurve(let p, let c1):
                newCommands.append(.quadCurve(translatePoint(p), c1: translatePoint(c1)))
            case .curve(let p, let c1, let c2):
                newCommands.append(.curve(translatePoint(p), c1: translatePoint(c1), c2: translatePoint(c2)))
            case .close:
                newCommands.append(.close)
            case .circle(let p, let r):
                newCommands.append(.circle(translatePoint(p), r))
            case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                newCommands.append(
                    .arc(center: translatePoint(center),
                         radius: radius,
                         startAngle: startAngle,
                         endAngle: endAngle,
                         clockwise: clockwise)
                )
            }
        }
        
        return newCommands
    }
    
    func invertedY() -> [Path.Command] {
        
        var newCommands = [Path.Command]()
        
        func invert(_ p: Vector2D) -> Vector2D {
            return Vector2D(p.x, -p.y)
        }
        
        for command in self {
            switch command {
            case .move(let p):
                newCommands.append(.move(invert(p)))
            case .line(let p):
                newCommands.append(.line(invert(p)))
            case .quadCurve(let p, let c1):
                newCommands.append(.quadCurve(invert(p), c1: invert(c1)))
            case .curve(let p, let c1, let c2):
                newCommands.append(.curve(invert(p), c1: invert(c1), c2: invert(c2)))
            case .close:
                newCommands.append(.close)
            case .circle(let p, let r):
                newCommands.append(.circle(invert(p), r))
            case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                newCommands.append(
                    .arc(center: invert(center),
                         radius: radius,
                         startAngle: startAngle,
                         endAngle: endAngle,
                         clockwise: clockwise)
                )
            }
        }
        
        return newCommands
    }
}

// MARK: - Path + Bounding Box

extension Path {
    
    fileprivate func calculateBoundingBox() -> Rect {
        
        var lowestX: Double?
        var highestX: Double?
        var lowestY: Double?
        var highestY: Double?
        
        func process(point: Vector2D) {
            lowestX = min(lowestX ?? point.x, point.x)
            lowestY = min(lowestY ?? point.y, point.y)
            highestX = max(highestX ?? point.x, point.x)
            highestY = max(highestY ?? point.y, point.y)
        }
        
        var lastPoint: Vector2D?
        for command in self.commands {
            switch command {
            case .move(let p):
                process(point: p)
                lastPoint = p
            case .line(let p):
                process(point: p)
                lastPoint = p
            case .curve(let p, let c1, let c2):
                if let lp = lastPoint {
                    let bb = BezierMath.boundingBox(x0: lp.x, y0: lp.y, x1: c1.x, y1: c1.y, x2: c2.x, y2: c2.y, x3: p.x, y3: p.y)
                    process(point: bb.bottomLeft)
                    process(point: bb.topRight)
                }
                lastPoint = p
            case .close:
                break
            case .circle(let p, let r):
                process(point: p.adding(x: r, y: r))
                process(point: p.subtracting(x: r, y: r))
            case .arc:
                break
            case .quadCurve(let p, let c1):
                // TODO: Need to calculate the bounding box of quad curve
                process(point: p)
                process(point: c1)
            }
        }
        
        let minX = lowestX ?? 0
        let minY = lowestY ?? 0
        let maxX = highestX ?? 0
        let maxY = highestY ?? 0
        
        return Rect(x: minX,
                    y: minY,
                    width: maxX - minX,
                    height: maxY - minY)
    }
}

// MARK: - Min / Max

extension Path {
    var maxY: Double { boundingBox.maxY }
    var minY: Double { boundingBox.minY }
}

// MARK: - Verify command validity

extension Array where Element == Path.Command {
    
    func containsInvalidValues() -> Bool {
        
        func isPointInvalid(_ point: Vector2D) -> Bool {
            return point.x.isNaN || point.y.isNaN || point.x.isInfinite || point.y.isInfinite
        }
        
        func isScalarInvalid(_ n: Double) -> Bool {
            return n.isNaN || n.isInfinite
        }
        
        for command in self {
            switch command {
            case .move(let p):
                if isPointInvalid(p) { return true }
            case .line(let p):
                if isPointInvalid(p) { return true }
            case .quadCurve(let p, let c1):
                if isPointInvalid(p) { return true }
                if isPointInvalid(c1) { return true }
            case .curve(let p, let c1, let c2):
                if isPointInvalid(p) { return true }
                if isPointInvalid(c1) { return true }
                if isPointInvalid(c2) { return true }
            case .close:
                break
            case .circle(let p, let radius):
                if isPointInvalid(p) { return true }
                if isScalarInvalid(radius) { return true }
            case .arc(let center, let radius, let startAngle, let endAngle, _):
                if isPointInvalid(center) { return true }
                if isScalarInvalid(radius) { return true }
                if isScalarInvalid(startAngle) { return true }
                if isScalarInvalid(endAngle) { return true }
            }
        }
        
        return false
    }
}
