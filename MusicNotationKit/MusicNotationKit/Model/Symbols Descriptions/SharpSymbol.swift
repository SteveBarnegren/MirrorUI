//
//  SharpSymbol.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class SharpSymbol: HorizontalLayoutItem, Positionable {    
    
    // HorizontalLayoutItem
    var layoutDuration: Time? = nil
    let leadingLayoutItems = [HorizontalLayoutItem]()
    let trailingLayoutItems = [HorizontalLayoutItem]()
    
    var position = Point.zero
}
