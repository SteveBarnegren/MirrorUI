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
    }
    
    enum DrawStyle {
        case stroke
        case fill
    }
    
    var commands = [Command]()
    var drawStyle = DrawStyle.stroke
    private(set) var boundingBox = Rect.zero
    
    init(commands: [Command] = []) {
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
                break;
            case .oval(_, _, _):
                break;
            case .circle(let p, let r):
                process(point: p.adding(x: r, y: r))
                process(point: p.subtracting(x: r, y: r))
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
