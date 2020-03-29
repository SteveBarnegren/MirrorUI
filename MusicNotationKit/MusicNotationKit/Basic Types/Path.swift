//
//  Path.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 16/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

struct Point {
    var x: Double
    var y: Double
    
    static let zero = Point(0, 0)
    
    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
    
    // Adding / Subtracting
    
    func adding(x: Double, y: Double) -> Point {
        return Point(self.x + x, self.y + y)
    }
    
    func adding(x: Double) -> Point {
        return Point(self.x + x, self.y)
    }
    
    func adding(y: Double) -> Point {
        return Point(self.x, self.y + y)
    }
    
    func subtracting(x: Double, y: Double) -> Point {
        return Point(self.x - x, self.y - y)
    }
    
    func subtracting(x: Double) -> Point {
        return Point(self.x - x, self.y)
    }
    
    func subtracting(y: Double) -> Point {
        return Point(self.x, self.y - y)
    }
}

struct Size {
    var width: Double
    var height: Double
}

struct Rect {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
    
    var maxY: Double {
        y + height
    }
    
    var minY: Double {
        return y
    }
    
    var bottomLeft: Point {
        return Point(x, y)
    }
    
    var bottomRight: Point {
        return Point(x + width, y)
    }
    
    var topLeft: Point {
        return Point(x, y + height)
    }
    
    var topRight: Point {
        return Point(x + width, y + height)
    }
    
    var center: Point {
        return Point(x + width/2, y + height/2)
    }
    
    func translated(x: Double, y: Double) -> Rect {
        return Rect(x: self.x + x, y: self.y + y, width: width, height: height)
    }
}

struct Path {
    
    enum Command {
        case move(Point)
        case line(Point)
        case curve(Point, c1: Point, c2: Point)
        case close
        case oval(Point, Size, Double)
    }
    
    enum DrawStyle {
        case stroke
        case fill
    }
    
    var commands = [Command]()
    var drawStyle = DrawStyle.stroke
    
    // Bounding box
    private var _boundingBoxCached: Rect?
    mutating func boundingBox() -> Rect {
        if let cachedValue = _boundingBoxCached {
            return cachedValue
        } else {
            let value = calculateBoundingBox()
            _boundingBoxCached = value
            return value
        }
    }
    
    init(commands: [Command] = []) {
        self.commands = commands
    }
    
    mutating func add(commands: [Command]) {
        self.commands.append(contentsOf: commands)
        _boundingBoxCached = nil
    }
    
    mutating func move(to point: Point) {
        commands.append(.move(point))
        _boundingBoxCached = nil
    }
    
    mutating func addLine(to point: Point) {
        commands.append(.line(point))
        _boundingBoxCached = nil
    }
    
    mutating func addCurve(to point: Point, c1: Point, c2: Point) {
        commands.append(.curve(point, c1: c1, c2: c2))
        _boundingBoxCached = nil
    }
    
    mutating func addOval(atPoint point: Point, withSize size: Size, rotation: Double) {
        commands.append(.oval(point, size, rotation))
        _boundingBoxCached = nil
    }
    
    mutating func addRect(_ r: Rect) {
        commands.append(.move(r.bottomLeft))
        commands.append(.line(r.topLeft))
        commands.append(.line(r.topRight))
        commands.append(.line(r.bottomRight))
        commands.append(.close)
        _boundingBoxCached = nil
    }
    
    mutating func close() {
        commands.append(.close)
        _boundingBoxCached = nil
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
            case .oval(let point, let size, let rotation):
                newCommands.append(.oval(translatePoint(point), size, rotation))
            }
        }
        
        commands = newCommands
        _boundingBoxCached = nil
    }
    
    func translated(x: Double, y: Double) -> Path {
        
        var copy = self
        copy.translate(x: x, y: y)
        return copy
    }
    
    // MARK: - Scale
    
    mutating func scale(_ scale: Double) {
        self.scale(x: scale, y: scale)
    }
    
    mutating func scale(x xScale: Double, y yScale: Double) {
        
        func scalePoint(_ p: Point) -> Point {
            return Point(p.x * xScale, p.y * yScale)
        }
        
        func scaleSize(_ s: Size) -> Size {
            return Size(width: s.width * xScale, height: s.height * yScale)
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
            }
        }
        
        commands = newCommands
        _boundingBoxCached = nil
    }
    
    func scaled(x xScale: Double, y yScale: Double) -> Path {
        
        var copy = self
        copy.scale(x: xScale, y: yScale)
        return copy
    }
    
    func scaled(_ scale: Double) -> Path {
        
        var copy = self
        copy.scale(x: scale, y: scale)
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
            }
        }
        
        self.commands = newCommands
        _boundingBoxCached = nil
    }
    
    func invertedY() -> Path {
        var copy = self
        copy.invertY()
        return copy
    }
}

extension Array where Element == Path.Command {
    
    func scaled(_ scale: Double) -> [Path.Command] {
        return self.scaled(x: scale, y: scale)
    }
    
    func scaled(x xScale: Double, y yScale: Double) -> [Path.Command] {
        
        func scalePoint(_ p: Point) -> Point {
            return Point(p.x * xScale, p.y * yScale)
        }
        
        func scaleSize(_ s: Size) -> Size {
            return Size(width: s.width * xScale, height: s.height * yScale)
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

extension Path {
    
    mutating func maxY() -> Double {
        return boundingBox().maxY
    }
    
    mutating func minY() -> Double {
        return boundingBox().minY
    }
}
