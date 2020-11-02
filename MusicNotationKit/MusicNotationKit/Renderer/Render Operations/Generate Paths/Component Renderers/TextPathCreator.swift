//
//  TextRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class TextPathCreator {
    
    func path(forCharacter character: Character) -> Path {
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 1)!

        var unichars = [UniChar](character.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        
        if gotGlyphs == false {
            return Path()
        }
        
        let cgPath = CTFontCreatePathForGlyph(font, glyphs[0], nil)!
        let path = Path(cgPath: cgPath)
        return path
    }
    
    func path(forString string: String) -> Path {
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 1)!
        let spacing = 0.05

        var unichars = [UniChar](string.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        
        if gotGlyphs == false {
            return Path()
        }
        
        var commands = [Path.Command]()
        
        // For a multi-character string, place each glyph next to the last
        if unichars.count > 1 {
            var xPos = 0.0
            for i in 0..<unichars.count {
                let glyphCommands = CTFontCreatePathForGlyph(font, glyphs[i], nil)!.pathCommands
                commands += glyphCommands.translated(x: xPos, y: 0)
                xPos += glyphCommands.width() + spacing
            }
        }
        // For a single character string we can skip this and just return the commands
        else {
            commands = CTFontCreatePathForGlyph(font, glyphs[0], nil)!.pathCommands
        }
        
        var path = Path(commands: commands)
        path.drawStyle = .fill
        return path
    }
}

extension CGPath {
    
    var pathCommands: [Path.Command] {
        
        var commands = [Path.Command]()
        
        func p(_ cgPoint: CGPoint) -> Point {
            return Point(Double(cgPoint.x), Double(cgPoint.y))
        }
        
        self.applyWithBlock { element in
            
            switch element.pointee.type {
            case .moveToPoint:
                commands.append(.move(p(element.pointee.points.pointee)))
            case .addLineToPoint:
                commands.append(.line(p(element.pointee.points.pointee)))
            case .addQuadCurveToPoint:
                commands.append(.quadCurve(p(element.pointee.points.pointee),
                                           c1: p(element.pointee.points.advanced(by: 1).pointee)))
            case .addCurveToPoint:
                commands.append(.curve(p(element.pointee.points.pointee),
                                       c1: p(element.pointee.points.advanced(by: 2).pointee),
                                       c2: p(element.pointee.points.advanced(by: 1).pointee)))
            case .closeSubpath:
                commands.append(.close)
            @unknown default:
                assertionFailure("Unknown element type")
            }
        }
        
        if !commands.isEmpty && commands.last != .close {
            commands.append(.close)
        }
        
        return commands
    }
}

extension Path {
    
    init(cgPath: CGPath) {
        
        var commands = [Path.Command]()
        
        func p(_ cgPoint: CGPoint) -> Point {
            return Point(Double(cgPoint.x), Double(cgPoint.y))
        }
        
        cgPath.applyWithBlock { element in
            
            switch element.pointee.type {
            case .moveToPoint:
                commands.append(.move(p(element.pointee.points.pointee)))
            case .addLineToPoint:
                commands.append(.line(p(element.pointee.points.pointee)))
            case .addQuadCurveToPoint:
                commands.append(.quadCurve(p(element.pointee.points.pointee),
                                           c1: p(element.pointee.points.advanced(by: 1).pointee)))
            case .addCurveToPoint:
                commands.append(.curve(p(element.pointee.points.pointee),
                                       c1: p(element.pointee.points.advanced(by: 1).pointee),
                                       c2: p(element.pointee.points.advanced(by: 2).pointee)))
            case .closeSubpath:
                commands.append(.close)
            @unknown default:
                assertionFailure("Unknown element type")
            }
        }
        
        self.init(commands: commands)
    }
}

class PathUtils {
    
    static func calculateSize(path: Path) -> Vector2D {
        
        // TODO: Calculate with the Bezier Box algorithm
        var minX = 0.0
        var minY = 0.0
        var maxX = 0.0
        var maxY = 0.0
        
        func process(_ p: Point) {
            minX = min(p.x, minX)
            minY = min(p.y, minY)
            maxX = max(p.x, maxX)
            maxY = max(p.y, maxY)
        }
        
        for command in path.commands {
            switch command {
            case .move(let p):
                process(p)
            case .line(let p):
                process(p)
            case .quadCurve(let p, let c1):
                process(p)
                process(c1)
            case .curve(let p, let c1, let c2):
                process(p)
                process(c1)
                process(c2)
            case .close:
                break
            case .circle(let p, let r):
                minX = min(minX, p.x - r)
                minY = min(minY, p.y - r)
                maxX = max(maxX, p.x + r)
                maxY = max(maxY, p.y + r)
            case .arc(center: let center, radius: let radius, startAngle: let startAngle, endAngle: let endAngle, clockwise: let clockwise):
                break
            }
        }
        
        return Vector2D(maxX - minX, maxY - minY)
    }
    
    static func centered(path: Path) -> Path {
                
        // TODO: Calculate with the Bezier Box algorithm
        var minX = 0.0
        var minY = 0.0
        var maxX = 0.0
        var maxY = 0.0
        
        func process(_ p: Point) {
            minX = min(p.x, minX)
            minY = min(p.y, minY)
            maxX = max(p.x, maxX)
            maxY = max(p.y, maxY)
        }
        
        for command in path.commands {
            switch command {
            case .move(let p):
                process(p)
            case .line(let p):
                process(p)
            case .quadCurve(let p, let c1):
                process(p)
               // process(c1)
            case .curve(let p, let c1, let c2):
                process(p)
                //process(c1)
                //process(c2)
            case .close:
                break
            case .circle(let p, let r):
                minX = min(minX, p.x - r)
                minY = min(minY, p.y - r)
                maxX = max(maxX, p.x + r)
                maxY = max(maxY, p.y + r)
            case .arc(center: let center, radius: let radius, startAngle: let startAngle, endAngle: let endAngle, clockwise: let clockwise):
                break
            }
        }
        
        
        let midX = minX.lerp(to: maxX, t: 0.5)
        let midY = minY.lerp(to: maxY, t: 0.5)

        return path.translated(x: -midX, y: -midY)
    }
    
}

