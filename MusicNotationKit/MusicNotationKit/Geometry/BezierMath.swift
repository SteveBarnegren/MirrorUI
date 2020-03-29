//
//  BezierMath.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class BezierMath {
    
    static func boundingBox(x0: Double, y0: Double, x1: Double, y1: Double, x2: Double, y2: Double, x3: Double, y3: Double) -> Rect {
        
        var tValues = [Double]()
        var edgePoints: [Point] = [Point(x0, y0), Point(x3, y3)]
        
        // Find T Values
        func findTValues(v0: Double, v1: Double, v2: Double, v3: Double) {
            let a = -3.0 * v0 + 9.0 * v1 - 9.0 * v2 + 3.0 * v3
            let b = 6.0 * v0 - 12.0 * v1 + 6.0 * v2
            let c = 3.0 * v1 - 3.0 * v0
            
            // Account for small values
            if (abs(a) < 1e-12) {
                if (abs(b) < 1e-12) {
                    return
                }
                let t = -c / b;
                if (0 < t && t < 1) {
                    tValues.append(t)
                }
                return
            }
            
            // Find t values
            let b2ac = b * b - 4 * c * a
            let sqrtb2ac = sqrt(b2ac)
            if (b2ac < 0) {
                return
            }
            let t1 = (-b + sqrtb2ac) / (2 * a)
            if (0 < t1 && t1 < 1) {
                tValues.append(t1)
            }
            let t2 = (-b - sqrtb2ac) / (2 * a)
            if (0 < t2 && t2 < 1) {
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
            let y = (mt * mt * mt * y0) + (3 * mt * mt * t * y1) + (3 * mt * t * t * y2) + (t * t * t * y3);
            let point = Point(x, y)
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
