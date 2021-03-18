//
//  HorizontalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalPositionerRenderOperation {
    
    func process(bars: [BarSlice], layoutWidth: Double) {
        
        let anchors = bars.map { $0.layoutAnchors }
            .joined()
            .filter { $0.enabled }
            .toArray()
            .appending(maybe: bars.last?.trailingBarlineAnchor)
        
        HorizontalLayoutSolver().solve(anchors: anchors, layoutWidth: layoutWidth)
    }
}
