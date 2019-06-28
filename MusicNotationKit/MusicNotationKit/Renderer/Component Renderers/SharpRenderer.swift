//
//  SharpRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class SharpRenderer {
    
    func paths(forSharp sharp: SharpSymbol) -> [Path] {
        
        let dotSize = 1.0
        
        var path = Path()
        path.addOval(atPoint: Point(sharp.xPosition, sharp.yPosition), withSize: Size(width: dotSize, height: dotSize), rotation: 0)
        path.drawStyle = .fill
        return [path]
    }
}
