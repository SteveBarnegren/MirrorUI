//
//  StavePositionUtils.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class StavePositionUtils {
    
    static func staveYOffset(forStavePostion stavePosition: Int) -> Double {
        return Double(stavePosition) / 2.0
    }
}
