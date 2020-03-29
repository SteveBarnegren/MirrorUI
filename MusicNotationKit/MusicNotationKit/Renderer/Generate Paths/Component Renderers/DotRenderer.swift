//
//  DotRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class DotRenderer {
    
    func paths(forDot dot: DotSymbol) -> [Path] {
        
        let dotSize = 0.5
        
        let commands: [Path.Command] = [
            .oval(Point(dot.xPosition, dot.yPosition), Size(width: dotSize, height: dotSize), 0)
        ]
        
        var path = Path(commands: commands)
        path.drawStyle = .fill
        return [path]
    }
}
