//
//  HorizontalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalPositionerRenderOperation {
    
    func process(bars: [Bar], layoutWidth: Double) {
        
        let anchors = bars.map { $0.layoutAnchors }
            .joined()
            .toArray()
            .appending(maybe: bars.last?.trailingBarlineAnchor)
        
        HorizontalLayoutSolver().solve(anchors: anchors, layoutWidth: layoutWidth)
    }
}
