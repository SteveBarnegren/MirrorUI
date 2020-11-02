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

