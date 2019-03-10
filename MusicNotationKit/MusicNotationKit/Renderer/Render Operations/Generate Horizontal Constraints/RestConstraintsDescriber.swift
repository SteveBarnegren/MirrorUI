//
//  RestConstraintsDescriber.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class RestConstraintsDescriber {
    
    func process(rest: Rest) {
        
        // Assumes that all rests are 1 unit wide (0.5 leading and 0.5 trailing)
        let leadingConstraint = HorizontalConstraint(values: [ConstraintValue(length: 0.5, priority: .required)])
        rest.leadingConstraints = [leadingConstraint]
        
        let trailingConstraint = HorizontalConstraint(values: [ConstraintValue(length: 0.5, priority: .required)])
        rest.trailingConstraints = [trailingConstraint]
        
    }
}
