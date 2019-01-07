//
//  StaveRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 23/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

class StaveRenderer {
    
    static func stavePaths(withWidth staveWidth: Double) -> [Path] {
     
        let numberOfLines = 5
        let totalStaveHeight = Double(numberOfLines-1)
    
        var paths = [Path]()
        
        var y = -totalStaveHeight/2
        for _ in (0..<numberOfLines) {
            
            var path = Path()
            path.drawStyle = .stroke
            path.move(to: Point(0, y))
            path.addLine(to: Point(staveWidth, y))
            paths.append(path)
            y += 1
        }
        
        return paths
        
    }
}
