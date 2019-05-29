//
//  ConstrainedDistance.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/05/2019.
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
    }
}

extension Array where Element == ConstrainedDistance {
    
    func minimumWidth(atPriority priority: ConstraintPriority) -> Double {
        return self.map { $0.minimumDistance(atPriority: priority) }.sum()
    }
}
