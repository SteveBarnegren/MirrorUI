//
//  Barline.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class Barline: HorizontalLayoutItem {
    
    // HorizontallyConstrained
    let layoutDuration: Time? = Time.init(value: 1, division: 64)
    var leadingConstraint: HorizontalConstraint
    var trailingConstraint: HorizontalConstraint
    let trailingLayoutItems = [HorizontalLayoutItem]()
    
    // HorizontallyPositionable
    var xPosition = Double(0)
    
    // Init
    
    init() {
        self.leadingConstraint = HorizontalConstraint(values: [ConstraintValue(length: 0.1, priority: ConstraintPriority.required)])
        
        self.trailingConstraint = HorizontalConstraint(values: [ConstraintValue(length: 0.1, priority: ConstraintPriority.required)])
    }
}
