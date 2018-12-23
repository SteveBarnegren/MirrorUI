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
    
    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
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
    
    init(commands: [Command] = []) {
        self.commands = commands
    }
    
    mutating func move(to point: Point) {
        commands.append(.move(point))
    }
    
    mutating func addLine(to point: Point) {
        commands.append(.line(point))
    }
    
    mutating func addCurve(to point: Point, c1: Point, c2: Point) {
        commands.append(.curve(point, c1: c1, c2: c2))
    }
    
    mutating func addOval(atPoint point: Point, withSize size: Size, rotation: Double) {
        commands.append(.oval(point, size, rotation))
    }
    
    mutating func addRect(_ r: Rect) {
        commands.append(.move(r.bottomLeft))
        commands.append(.line(r.topLeft))
        commands.append(.line(r.topRight))
        commands.append(.line(r.bottomRight))
        commands.append(.close)
    }

    mutating func close() {
        commands.append(.close)
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
    
}
