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
    
    // HorizontalLayoutItem
    let leadingLayoutItems = [HorizontalLayoutItem]()
    let trailingLayoutItems = [HorizontalLayoutItem]()
    
    // Horizontally Constrained
    var layoutDuration: Time? = nil
    var xPosition: Double = 0
}
