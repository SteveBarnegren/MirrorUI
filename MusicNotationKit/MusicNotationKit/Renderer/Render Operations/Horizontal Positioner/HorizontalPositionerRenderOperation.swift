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
        
        var anchors = bars.map { $0.layoutAnchors }.joined().toArray()
        if let endBarlineAnchor = bars.last?.trailingBarlineAnchor {
            anchors.append(endBarlineAnchor)
        }
        
        HorizontalLayoutSolver().solve(anchors: anchors, layoutWidth: layoutWidth)
    }
}
