//
//  SharpSymbol.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class SharpSymbol: HorizontalLayoutItem, Positionable {
    
    // Do we need this stuff?
    var layoutDuration: Time? = nil
    var leadingConstraint = HorizontalConstraint.zero
    var trailingConstraint = HorizontalConstraint.zero
    var trailingLayoutItems = [HorizontalLayoutItem]()
    
    var position = Point.zero
}
