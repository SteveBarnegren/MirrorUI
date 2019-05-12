//
//  DotSymbol.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class DotSymbol: HorizontallyPlacedSymbol {
    
    // Horizontally Constrained
    var layoutDuration: Time? = nil
    var leadingConstraints = [HorizontalConstraint]()
    var trailingConstraints = [HorizontalConstraint]()
    var xPosition: Double = 0
}
