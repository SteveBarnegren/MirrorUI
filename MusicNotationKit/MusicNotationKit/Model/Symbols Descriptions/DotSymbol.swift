//
//  DotSymbol.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class DotSymbol: HorizontalLayoutItem, Positionable {
    
    var position: Point = .zero
    var pitch = Pitch.c4
    
    // Horizontally Constrained
    var layoutDuration: Time? = nil
    var leadingConstraint = HorizontalConstraint.zero
    var trailingConstraint = HorizontalConstraint.zero
    let trailingLayoutItems = [HorizontalLayoutItem]()
    var xPosition: Double = 0
}
