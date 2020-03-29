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
        
        var path = Path(circleWithCenter: dot.position, radius: dotSize/2)
        path.drawStyle = .fill
        return [path]
    }
}
