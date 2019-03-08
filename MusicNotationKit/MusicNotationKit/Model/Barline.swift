//
//  Barline.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class Barline: HorizontallyConstrained {
    
    let layoutDuration: Time? = Time.init(value: 1, division: 64)
    var leadingWidth = 0.1
    var trailingWidth = 0.1
    var leadingConstraints: [HorizontalConstraint]
    var trailingConstraints: [HorizontalConstraint]
    
    var xPosition = Double(0)
    
    init() {
        let leadingConstraint = HorizontalConstraint(values: [ConstraintValue(length: 0.1, priority: ConstraintPriority.required)])
        self.leadingConstraints = [leadingConstraint]
        
        let trailingConstraint = HorizontalConstraint(values: [ConstraintValue(length: 0.1, priority: ConstraintPriority.required)])
        self.trailingConstraints = [trailingConstraint]
    }
}
