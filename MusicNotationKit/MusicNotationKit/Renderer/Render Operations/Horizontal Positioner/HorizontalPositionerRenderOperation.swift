//
//  HorizontalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalPositionerRenderOperation: RenderOperation {
    
    func process(composition: Composition, layoutWidth: Double) {
        
        let anchors = LayoutAnchorsBuilder().makeAnchors(from: composition)
        HorizontalLayoutSolver().solve(anchors: anchors, layoutWidth: layoutWidth)
    }
}
