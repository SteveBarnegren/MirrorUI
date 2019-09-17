//
//  HorizontalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalPositionerRenderOperation: RenderOperation {
    
    private let layoutAnchorsStitcher = BarLayoutAnchorsStitcher()
    
    func process(composition: Composition, layoutWidth: Double) {
        
        layoutAnchorsStitcher.stichAnchors(for: composition.bars)
        let anchors = composition.bars.map { $0.layoutAnchors }.joined().toArray()
        HorizontalLayoutSolver().solve(anchors: anchors, layoutWidth: layoutWidth)
    }
}
