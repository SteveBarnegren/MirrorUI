//
//  StaveRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 23/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

class StaveRenderer {
    
    static func stavePaths(forCanvasSize canvasSize: Size) -> [Path] {
     
        let midY = canvasSize.height/2
        let numberOfLines = 5
        let totalStaveHeight = Double(numberOfLines-1)
    
        var paths = [Path]()
        
        var y = midY - totalStaveHeight/2
        for _ in (0..<numberOfLines) {
            
            var path = Path()
            path.drawStyle = .stroke
            path.move(to: Point(0, y))
            path.addLine(to: Point(canvasSize.width, y))
            paths.append(path)
            y += 1
        }
        
        return paths
        
    }
}
