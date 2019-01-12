//
//  HorizontalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalPositioner {
    
    func process(composition: Composition, layoutWidth: Double) {
        
        var items = composition.bars.map { constrainedItems(forBar: $0) }.joined().toArray()
        
        let positions = HorizontalConstraintSolver().solve(items, layoutWidth: layoutWidth)
        for (index, position) in zip(items.indices, positions) {
            items[index].xPosition = position
        }
    }
    
    private func constrainedItems(forBar bar: Bar) -> [HorizontallyConstrained] {
        
        // We'll just process a single note sequence for now
        var items = [HorizontallyConstrained]()
        items.append(bar.leadingBarline)
        
        for note in bar.sequences[0].notes {
            items.append(note)
        }
        
        return items
    }
}

fileprivate class Spacer: HorizontallyConstrained {
    var layoutDuration: Time?
    var leadingWidth: Double
    var trailingWidth: Double
    var xPosition: Double = 0
    
    init(width: Double) {
        self.leadingWidth = width/2
        self.trailingWidth = width/2
        self.layoutDuration = nil
    }
}
