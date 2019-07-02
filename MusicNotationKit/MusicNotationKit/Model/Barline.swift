//
//  Barline.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class Barline: HorizontalLayoutItem {
    
    // HorizontallyConstrained
    let layoutDuration: Time? = Time.init(value: 1, division: 64)
    
    // HorizontallyPositionable
    var xPosition = Double(0)
}
