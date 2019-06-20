//
//  HorizontalLayoutSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalLayoutSolver {
    
    func solve(anchors: [LayoutAnchor], layoutWidth: Double) {
        
        // Solve constant constraints
        for constraint in anchors.map({ $0.trailingConstraints }).joined() {
            switch constraint.value {
            case .greaterThan(let v):
                constraint.resolvedValue = v
            }
        }
        
        // Apply the value to the notes
        var xPos = Double(0)
        for anchor in anchors {
            xPos += anchor.width/2
            for constraint in anchor.leadingConstraints {
                xPos += constraint.resolvedValue
            }

            anchor.resolvedPosition = xPos
            xPos += anchor.width/2
        }
        
        // Apply anchor positions to items
        anchors.forEach { $0.item.xPosition = $0.resolvedPosition }
        
        // DEBUG - print anchor positions
        print("Anchor positions")
        for anchor in anchors {
            print("\(anchor.item.xPosition)")
        }
    }

}
