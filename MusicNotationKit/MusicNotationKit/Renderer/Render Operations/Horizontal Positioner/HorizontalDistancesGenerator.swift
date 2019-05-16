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
    var leadingDistances = [ConstrainedDistance]()
    var leadingLayoutOffset = Double(0)
    var trailingLayoutOffset = Double(0)
    
    func minimumDistance(atPriority priority: ConstraintPriority) -> Double {
        if leadingDistances.isEmpty {
            return constraints.map { $0.minimumDistance(atPriority: priority) }.sum()
        } else {
            return leadingLayoutOffset + leadingDistances.map { $0.minimumDistance(atPriority: priority) }.sum()
        }
        
//        let constraintsDist = constraints.map { $0.minimumDistance(atPriority: priority) }.sum()
//        let leadingDist = leadingDistances.map { $0.minimumDistance(atPriority: priority) }.sum()
//        return constraintsDist + leadingDist
    }
}

class HorizontalDistancesGenerator {
    
    func makeConstrainedDistances(fromItems items: [HorizontalLayoutItem]) -> [ConstrainedDistance] {
        
        var distances = [ConstrainedDistance]()
        
        var previousItem: HorizontalLayoutItem?
        
        for item in items {
            let distance = ConstrainedDistance()
            
            if let previous = previousItem {
                distance.constraints.append(previous.trailingConstraint)
                distance.leadingDistances = makeConstrainedDistances(fromItems: previous.trailingLayoutItems)
                distance.leadingLayoutOffset = previous.trailingLayoutOffset
                distance.trailingLayoutOffset = item.leadingLayoutOffset
            }
            distance.constraints.append(item.leadingConstraint)
            distance.toItem = item
            distance.preferredPercent = previousItem?.layoutDuration?.barPct
            distances.append(distance)
            
            previousItem = item
        }
        
        if let last = items.last {
            let distance = ConstrainedDistance()
            distance.constraints.append(last.trailingConstraint)
            distance.preferredPercent = previousItem?.layoutDuration?.barPct
            distances.append(distance)
        }
        
        return distances
    }
}
