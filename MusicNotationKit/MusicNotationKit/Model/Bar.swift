//
//  Bar.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
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
        
        let requiredTrailingValue = ConstraintValue(length: 0.1, priority: ConstraintPriority.required)
        let paddedTrailingValue = ConstraintValue(length: 0.1 + 1, priority: ConstraintPriority.regular)
        
        let trailingConstraint = HorizontalConstraint(values: [requiredTrailingValue, paddedTrailingValue])
        self.trailingConstraints = [trailingConstraint]
    }
}

public class Bar {
    var sequences = [NoteSequence]()
    
    let leadingBarline = Barline()

    var duration: Time {
        return sequences.reduce(Time.zero) { $0 + $1.duration }
    }
    
    public init() {}
    
    public func add(sequence: NoteSequence) {
        self.sequences.append(sequence)
    }
}
