//
//  StaveSpace.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 04/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

struct StaveSpace {
    
    enum Sign {
        case positive
        case negative
    }
    
    let space: Int
    let sign: Sign
    
    init(space: Int, sign: Sign) {
        self.space = space
        self.sign = sign
    }    
}
