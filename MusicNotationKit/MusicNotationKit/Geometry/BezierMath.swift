//
//  BezierMath.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class BezierMath {
    
    static func boundingBoxForQuadBezier(from start: Vector2D, cp: Vector2D, to end: Vector2D) -> Rect {
        
        // convert the quad bezier to cubic and use cubic bounding box method
        let cp1x = start.x + (2.0/3.0) * (cp.x-start.x)
        let cp1y = start.y + (2.0/3.0) * (cp.y-start.y)
        
        let cp2x = end.x + (2.0/3.0) * (cp.x-end.x)
        let cp2y = end.y + (2.0/3.0) * (cp.y-end.y)
        
        return boundingBox(x0: start.x, y0: start.y, x1: cp1x, y1: cp1y, x2: cp2x, y2: cp2y, x3: end.x, y3: end.y)
    }
    
    static func boundingBoxForCubicBezier(from start: Vector2D, c1: Vector2D, c2: Vector2D, to end: Vector2D) -> Rect {
        return boundingBox(x0: start.x, y0: start.y, x1: c1.x, y1: c1.y, x2: c2.x, y2: c2.y, x3: end.x, y3: end.y)
    }
    
    static func boundingBox(x0: Double, y0: Double, x1: Double, y1: Double, x2: Double, y2: Double, x3: Double, y3: Double) -> Rect {
        
        var tValues = [Double]()
        var edgePoints: [Vector2D] = [Vector2D(x0, y0), Vector2D(x3, y3)]
        
        // Find T Values
        func findTValues(v0: Double, v1: Double, v2: Double, v3: Double) {
            let a = -3.0 * v0 + 9.0 * v1 - 9.0 * v2 + 3.0 * v3
            let b = 6.0 * v0 - 12.0 * v1 + 6.0 * v2
            let c = 3.0 * v1 - 3.0 * v0
            
            // Account for small values
            if abs(a) < 1e-12 {
                if abs(b) < 1e-12 {
                    return
                }
                let t = -c / b
                if 0 < t && t < 1 {
                    tValues.append(t)
                }
                return
            }
            
            // Find t values
            let b2ac = b * b - 4 * c * a
            let sqrtb2ac = sqrt(b2ac)
            if b2ac < 0 {
                return
            }
            let t1 = (-b + sqrtb2ac) / (2 * a)
            if 0 < t1 && t1 < 1 {
                tValues.append(t1)
            }
            let t2 = (-b - sqrtb2ac) / (2 * a)
            if 0 < t2 && t2 < 1 {
                tValues.append(t2)
            }
        }
        
        // Find T values for x and y
        findTValues(v0: x0, v1: x1, v2: x2, v3: x3)
        findTValues(v0: y0, v1: y1, v2: y2, v3: y3)
        
        // Find points for t values
        for t in tValues {
            let mt = 1 - t
            let x = (mt * mt * mt * x0) + (3 * mt * mt * t * x1) + (3 * mt * t * t * x2) + (t * t * t * x3)
            let y = (mt * mt * mt * y0) + (3 * mt * mt * t * y1) + (3 * mt * t * t * y2) + (t * t * t * y3)
            let point = Vector2D(x, y)
            edgePoints.append(point)
        }
        
        // Find the min / max values
        let minX = edgePoints.map { $0.x }.min()!
        let maxX = edgePoints.map { $0.x }.max()!
        let minY = edgePoints.map { $0.y }.min()!
        let maxY = edgePoints.map { $0.y }.max()!
        
        return Rect(x: minX,
                    y: minY,
                    width: maxX - minX,
                    height: maxY - minY)
    }
}