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
        items.append(makePostBarlineSpacer())
        
        for (playableItem, isLast) in bar.sequences[0].playables.enumeratedWithLastItemFlag() {
            items.append(playableItem)
            items.append(isLast ? makeLastNoteSpacer() : makePostNoteSpacer())
        }
        
        return items
    }
    
    private func makePostBarlineSpacer() -> Spacer {
        
        let spacer = Spacer()
        spacer.add(value: ConstraintValue(length: 1, priority: ConstraintPriority.regular))
        return spacer
    }
    
    private func makePostNoteSpacer() -> Spacer {
        
        let spacer = Spacer()
        spacer.add(value: ConstraintValue(length: 0.5, priority: ConstraintPriority.regular))
        return spacer
    }
    
    private func makeLastNoteSpacer() -> Spacer {
        
        let spacer = Spacer()
        spacer.add(value: ConstraintValue(length: 1, priority: ConstraintPriority.regular))
        return spacer
    }
}

fileprivate class Spacer: HorizontallyConstrained {
 
    var layoutDuration: Time? = nil
    var xPosition: Double = 0
    
    let leadingConstraints = [HorizontalConstraint]()
    var trailingConstraints: [HorizontalConstraint] {
        let constraint = HorizontalConstraint(values: constraintValues)
        return [constraint]
    }
    
    private var constraintValues = [ConstraintValue]()
    
    func add(value: ConstraintValue) {
        constraintValues.append(value)
    }
}