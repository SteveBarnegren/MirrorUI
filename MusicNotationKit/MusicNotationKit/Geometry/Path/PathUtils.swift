//
//  PathUtils.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

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
        
        func process(rect: Rect) {
            minX = min(rect.minX, minX)
            minY = min(rect.minY, minY)
            maxX = max(rect.maxX, maxX)
            maxY = max(rect.maxY, maxY)
        }
        
        var lastPoint: Point?
        
        for command in path.commands {
            switch command {
            case .move(let p):
                process(p)
                lastPoint = p
            case .line(let p):
                process(p)
                lastPoint = p
            case .quadCurve(let p, let c1):
                if let start = lastPoint {
                    let bb = BezierMath.boundingBoxForQuadBezier(from: start, cp: c1, to: p)
                    process(rect: bb)
                }
                lastPoint = p
            case .curve(let p, let c1, let c2):
                if let start = lastPoint {
                    let bb = BezierMath.boundingBoxForCubicBezier(from: start, c1: c1, c2: c2, to: p)
                    process(rect: bb)
                }
                lastPoint = p
            case .close:
                lastPoint = nil
            case .circle(let p, let r):
                minX = min(minX, p.x - r)
                minY = min(minY, p.y - r)
                maxX = max(maxX, p.x + r)
                maxY = max(maxY, p.y + r)
                lastPoint = nil
            case .arc(center: let center, radius: let radius, startAngle: let startAngle, endAngle: let endAngle, clockwise: let clockwise):
                lastPoint = nil
            }
        }
        
        return Vector2D(maxX - minX, maxY - minY)
    }
    
    static func centered(path: Path) -> Path {
        let size = calculateSize(path: path)
        return path.translated(x: -size.x/2, y: -size.y/2)
    }
    
}
