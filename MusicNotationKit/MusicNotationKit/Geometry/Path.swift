//
//  Path.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 16/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

struct Path {
    
    enum Command {
        case move(Point)
        case line(Point)
        case curve(Point, c1: Point, c2: Point)
        case close
        case circle(Point, Double) // Center, Radius
        case oval(Point, Size, Double)
        case arc(center: Point, radius: Double, startAngle: Double, endAngle: Double, clockwise: Bool)
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
    
    init(circleWithCenter center: Point, radius: Double) {
        let command = Path.Command.circle(center, radius)
        self.init(commands: [command])
    }
}

extension Path {
    
    // MARK: - Translate
    
    mutating func translate(x xOffset: Double, y yOffset: Double) {
        
        func translatePoint(_ p: Point) -> Point {
            return Point(xOffset + p.x, yOffset + p.y)
        }
        
        var newCommands = [Path.Command]()
        
        for command in commands {
            switch command {
            case .move(let p):
                newCommands.append(.move(translatePoint(p)))
            case .line(let p):
                newCommands.append(.line(translatePoint(p)))
            case .curve(let p, let c1, let c2):
                newCommands.append(.curve(translatePoint(p), c1: translatePoint(c1), c2: translatePoint(c2)))
            case .close:
                newCommands.append(.close)
            case .circle(let p, let r):
                newCommands.append(.circle(translatePoint(p), r))
            case .oval(let point, let size, let rotation):
                newCommands.append(.oval(translatePoint(point), size, rotation))
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
        
        commands = newCommands
        boundingBox = boundingBox.translated(x: xOffset, y: yOffset)
    }
    
    func translated(x: Double, y: Double) -> Path {
        
        var copy = self
        copy.translate(x: x, y: y)
        return copy
    }
    
    // MARK: - Scale
    
    mutating func scale(_ scale: Double) {
   
        func scalePoint(_ p: Point) -> Point {
            return Point(p.x * scale, p.y * scale)
        }
        
        func scaleSize(_ s: Size) -> Size {
            return Size(width: s.width * scale, height: s.height * scale)
        }
        
        var newCommands = [Path.Command]()
        
        for command in commands {
            switch command {
            case .move(let p):
                newCommands.append(.move(scalePoint(p)))
            case .line(let p):
                newCommands.append(.line(scalePoint(p)))
            case .curve(let p, let c1, let c2):
                newCommands.append(.curve(scalePoint(p), c1: scalePoint(c1), c2: scalePoint(c2)))
            case .close:
                newCommands.append(.close)
            case .oval(let point, let size, let rotation):
                newCommands.append(.oval(scalePoint(point), scaleSize(size), rotation))
            case .circle(let p, let r):
                newCommands.append(.circle(scalePoint(p), r * scale))
            case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                newCommands.append(
                    .arc(center: scalePoint(center),
                         radius: radius * scale,
                         startAngle: startAngle,
                         endAngle: endAngle,
                         clockwise: clockwise)
                )
            }
        }
        
        commands = newCommands
        
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
        
        var newCommands = [Command]()
        
        func invert(_ p: Point) -> Point {
            return Point(p.x, -p.y)
        }
        
        for command in self.commands {
            switch command {
            case .move(let p):
                newCommands.append(.move(invert(p)))
            case .line(let p):
                newCommands.append(.line(invert(p)))
            case .curve(let p, let c1, let c2):
                newCommands.append(.curve(invert(p), c1: invert(c1), c2: invert(c2)))
            case .close:
                newCommands.append(.close)
            case .oval(let p, let size, let rotation):
                newCommands.append(.oval(invert(p), size, rotation))
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
        
        self.commands = newCommands
        
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
        
        func scalePoint(_ p: Point) -> Point {
            return Point(p.x * scale, p.y * scale)
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
            case .curve(let p, let c1, let c2):
                newCommands.append(.curve(scalePoint(p), c1: scalePoint(c1), c2: scalePoint(c2)))
            case .close:
                newCommands.append(.close)
            case .oval(let point, let size, let rotation):
                newCommands.append(.oval(scalePoint(point), scaleSize(size), rotation))
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
    
    func translated(x: Double, y: Double) -> [Path.Command] {
        
        var newCommands = [Path.Command]()
        
        func translatePoint(_ p: Point) -> Point {
            return Point(p.x + x, p.y + y)
        }
        
        for command in self {
            switch command {
            case .move(let p):
                newCommands.append(.move(translatePoint(p)))
            case .line(let p):
                newCommands.append(.line(translatePoint(p)))
            case .curve(let p, let c1, let c2):
                newCommands.append(.curve(translatePoint(p), c1: translatePoint(c1), c2: translatePoint(c2)))
            case .close:
                newCommands.append(.close)
            case .oval(let p, let size, let rotation):
                newCommands.append(.oval(translatePoint(p), size, rotation))
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
}

// MARK: - Path + Bounding Box

extension Path {
    
    fileprivate func calculateBoundingBox() -> Rect {
        
        var lowestX: Double?
        var highestX: Double?
        var lowestY: Double?
        var highestY: Double?
        
        func process(point: Point) {
            lowestX = min(lowestX ?? point.x, point.x)
            lowestY = min(lowestY ?? point.y, point.y)
            highestX = max(highestX ?? point.x, point.x)
            highestY = max(highestY ?? point.y, point.y)
        }
        
        var lastPoint: Point?
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
            case .oval:
                break
            case .circle(let p, let r):
                process(point: p.adding(x: r, y: r))
                process(point: p.subtracting(x: r, y: r))
            case .arc:
                break
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
        
        func isPointInvalid(_ point: Point) -> Bool {
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
            case .curve(let p, let c1, let c2):
                if isPointInvalid(p) { return true }
                if isPointInvalid(c1) { return true }
                if isPointInvalid(c2) { return true }
            case .close:
                break
            case .circle(let p, let radius):
                if isPointInvalid(p) { return true }
                if isScalarInvalid(radius) { return true }
            case .oval:
                fatalError("unsupported")
            case .arc(let center, let radius, let startAngle, let endAngle, _):
                if isPointInvalid(center) { return true }
                if isScalarInvalid(radius) { return true }
                if isScalarInvalid(startAngle) { return true }
                if isScalarInvalid(endAngle) { return true }
            }
        }
        
        return false
    }
    
    /*
    func invalidValuesError() -> String? {
        
        var valuesAreInvalid = false
        var errorString = String()
        
        func isPointValid(_ point: Point) -> Bool {
            if point.x.isNaN || point.y.isNaN || point.x.isInfinite || point.y.isInfinite {
                return false
            } else {
                return true
            }
        }
        
        func add(_ string: String) {
            if errorString.isEmpty {
                errorString.append(string)
            } else {
                errorString.append("\n\(string)")
            }
        }
        
        for command in self {
            switch command {
            case .line(let p):
                
            }
        }
    }
 */
}



/*
extension Array where Element == Path.Command {
    
    func reversedCommands() -> [Path.Command] {
           
        var nextControlPoints: (cp1: Vector2D, cp2: Vector2D)?
        
        var newCommands = [Path.Command]()
        
        for command in self.reversed() {
            switch command {
            case .move(let p):
                if let nextPoints = nextControlPoints {
                    newCommands.append(.curve(to: point, cp1: nextPoints.cp1, cp2: nextPoints.cp2))
                } else {
                    newCommands.append(.point(point))
                }
                
            }
        }
        
        
        
           for command in self.reversed() {
               switch command {
               case .point(let point):
                   if let nextPoints = nextControlPoints {
                       newCommands.append(.curve(to: point, cp1: nextPoints.cp1, cp2: nextPoints.cp2))
                   } else {
                       newCommands.append(.point(point))
                   }
                   nextControlPoints = nil
               case .curve(let to, let cp1, let cp2):
                   if let nextPoints = nextControlPoints {
                       newCommands.append(.curve(to: to, cp1: nextPoints.cp1, cp2: nextPoints.cp2))
                   } else {
                       newCommands.append(.point(to))
                   }
                   nextControlPoints = (cp2, cp1)
               case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                   newCommands.append(
                       .arc(center: center, radius: radius, startAngle: endAngle, endAngle: startAngle, clockwise: !clockwise)
                   )
               }
           }
           
           return newCommands
       }
}
*/
