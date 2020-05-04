//
//  UInt+Extensions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 04/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

extension UInt {
    
    init(abs value: Int) {
        self = UInt(abs(value))
    }
}
