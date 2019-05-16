//
//  HorizontalDistancesGenerator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 16/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class ConstrainedDistance {
    var toItem: HorizontalLayoutItem? = nil
    var constraints = [HorizontalConstraint]()
    var preferredPercent: Double?
    var solvedDistance = Double(0)
    var xPosition = Double(0)
    var isSolved = false
    
    func minimumDistance(atPriority priority: ConstraintPriority) -> Double {
        return constraints.map { $0.minimumDistance(atPriority: priority) }.sum()
    }
}

class HorizontalDistancesGenerator {
    
    func makeConstrainedDistances(fromItems items: [HorizontalLayoutItem]) -> [ConstrainedDistance] {
        
        var distances = [ConstrainedDistance]()
        
        var lastItem: HorizontalLayoutItem?
        
        for item in items {
            let distance = ConstrainedDistance()
            
            if let last = lastItem {
                distance.constraints.append(last.trailingConstraint)
            }
            distance.constraints.append(item.leadingConstraint)
            distance.toItem = item
            distance.preferredPercent = lastItem?.layoutDuration?.barPct
            distances.append(distance)
            
            lastItem = item
        }
        
        if let last = items.last {
            let distance = ConstrainedDistance()
            distance.constraints.append(last.trailingConstraint)
            distance.preferredPercent = lastItem?.layoutDuration?.barPct
            distances.append(distance)
        }
        
        return distances
    }
}
