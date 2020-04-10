//
//  BinaryInteger+Parity.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

public extension BinaryInteger {
    
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var isOdd: Bool {
        return !isEven
    }
}
