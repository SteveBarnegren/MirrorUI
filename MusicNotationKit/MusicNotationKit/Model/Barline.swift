//
//  Barline.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class Barline: HorizontalLayoutItem {
    
    // HorizontalLayoutItem
    let layoutDuration: Time? = nil
    let leadingLayoutItems = [AdjacentLayoutItem]()
    let trailingLayoutItems = [AdjacentLayoutItem]()
    let horizontalLayoutWidth = 0.2
    
    // HorizontallyPositionable
    var xPosition = Double(0)
}
