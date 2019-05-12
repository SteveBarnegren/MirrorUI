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
        
        var path = Path()
        path.addOval(atPoint: Point(dot.xPosition, 0), withSize: Size(width: dotSize, height: dotSize), rotation: 0)
        path.drawStyle = .fill
        return [path]
    }
}
