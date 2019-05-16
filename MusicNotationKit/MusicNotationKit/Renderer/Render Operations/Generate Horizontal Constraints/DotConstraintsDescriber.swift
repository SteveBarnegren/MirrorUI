//
//  DotConstraintsDescriber.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class DotConstraintsDescriber {
    
    func process(dotSymbol: DotSymbol) {
        
        let dotSize = 0.5
        let dotSeparation = 0.25

        dotSymbol.leadingConstraint = HorizontalConstraint(values: [
            ConstraintValue(length: dotSize, priority: .required),
            ConstraintValue(length: dotSize + dotSeparation, priority: .regular)
            ])
        
        dotSymbol.trailingConstraint = HorizontalConstraint(values: [
            ConstraintValue(length: dotSize, priority: .required)
            ])
    }
}
