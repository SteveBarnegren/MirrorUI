//
//  BarlineRender.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 07/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class BarlineRenderer {
    
    func paths(forBarline barline: Barline) -> [Path] {
        
        let width = 0.2
        let height = 4.0
        
        let rect = Rect(x: barline.xPosition - width/2,
                        y: -height/2,
                        width: width,
                        height: height)
        
        var path = Path(rect: rect)
        path.drawStyle = .fill
        return [path]
    }

}
