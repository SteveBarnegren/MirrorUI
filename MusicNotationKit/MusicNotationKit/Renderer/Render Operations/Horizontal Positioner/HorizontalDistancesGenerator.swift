//
//  HorizontalDistancesGenerator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 16/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation



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
