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
    var leadingConstraint = HorizontalConstraint.zero
    var trailingConstraint = HorizontalConstraint.zero
    var xPosition: Double = 0
}
