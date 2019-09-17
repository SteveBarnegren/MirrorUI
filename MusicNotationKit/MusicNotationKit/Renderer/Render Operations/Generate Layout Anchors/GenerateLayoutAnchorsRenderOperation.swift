//
//  GenerateBarLayoutAnchorsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateBarLayoutAnchorsRenderOperation: RenderOperation {
    
    private let layoutAnchorsBuilder = BarLayoutAnchorsBuilder()
    
    func process(composition: Composition, layoutWidth: Double) {
        
        for bar in composition.bars {
            let anchors = layoutAnchorsBuilder.buildAnchors(for: bar)
            bar.layoutAnchors = anchors
        }
    }
}
