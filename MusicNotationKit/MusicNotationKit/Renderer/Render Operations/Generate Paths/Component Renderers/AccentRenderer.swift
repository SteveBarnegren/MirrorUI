//
//  AccentRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 26/10/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class AccentRenderer {
    
    func paths(forAccent accent: Accent, xPos: Double) -> [Path] {
        
        // Constants
        let width = 1.3
        let height = 0.7
        let lineThickness = 0.15
        
        let yPos = StavePositionUtils.staveYOffset(forStavePostion: accent.stavePosition)
                
        // Makes a point, taking localised coordinates, and moving to the correct absolute position
        func p(_ x: Double, y: Double) -> Point {
            return Point(xPos + x, yPos + y)
        }
        
        var commands = [Path.Command]()
        // Top arm (outside)
        commands.append(.move(p(-width/2, y: height/2)))
        // Right middle (outside of point)
        commands.append(.line(p(width/2, y: 0)))
        // Bottom arm (outside)
        commands.append(.line(p(-width/2, y: -height/2)))
        // Bottom arm (inside)
        commands.append(.line(p(-width/2, y: -height/2 + lineThickness)))
        // Point (inside)
        let xyRatio = width / (height/2)
        let xDiff = ((height/2)-lineThickness) * xyRatio
        commands.append(.line(p(-width/2 + xDiff, y: 0)))
        // Top arm (inside)
        commands.append(.line(p(-width/2, y: height/2 - lineThickness)))
        commands.append(.close)

        var path = Path(commands: commands)
        path.drawStyle = .fill
        
        return [path]
    }

}
