//
//  HorizontalLayoutSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalLayoutSolver {
    
    let fixedDistanceSolver = FixedDistanceLayoutSolver()
    let layoutTimingSolver = LayoutTimingSolver()
    
    func solve(anchors: [LayoutAnchor], layoutWidth: Double) {
                
        func applyAnchorPositions() {
            anchors.forEach { $0.apply() }
        }
        
        anchors.forEach { $0.reset() }
        fixedDistanceSolver.solve(anchors: anchors)
        layoutTimingSolver.distributeTime(toAnchors: anchors, layoutWidth: layoutWidth)
        applyAnchorPositions()
    }
}
