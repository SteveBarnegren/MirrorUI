//
//  Array+PathCommand.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

extension Array where Element == Path.Command {
    
    // TODO: Use proper bezier curve measuring
    func width() -> Double {
        
        var minX = 0.0
        var maxX = 0.0
        
        func process(_ p: Point) {
            minX = Swift.min(minX, p.x)
            maxX = Swift.max(maxX, p.x)
        }
        
        for command in self {
            switch command {
            case .move(let p):
                process(p)
            case .line(let p):
                process(p)
            case .quadCurve(let p, let c1):
                process(p)
            case .curve(let p, let c1, let c2):
                process(p)
            case .close:
                break
            case .circle(let p, let r):
                minX = Swift.min(minX, p.x - r)
                maxX = Swift.max(maxX, p.x + r)
            case .arc(center: let center, radius: let radius, startAngle: let startAngle, endAngle: let endAngle, clockwise: let clockwise):
                break
            }
        }
        
        return maxX - minX
    }
}
