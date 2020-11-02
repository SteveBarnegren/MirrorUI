//
//  Path+CGPath.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

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
                commands.append(.quadCurve(p(element.pointee.points.advanced(by: 1).pointee),
                                           c1: p(element.pointee.points.pointee)))
            case .addCurveToPoint:
                commands.append(.curve(p(element.pointee.points.advanced(by: 2).pointee),
                                       c1: p(element.pointee.points.pointee),
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
