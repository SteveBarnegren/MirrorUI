//
//  SignedNumeric+Extensions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

extension SignedNumeric {
    
    func inverted(if expression: () -> Bool) -> Self {
        if expression() == true {
            return -self
        } else {
            return self
        }
    }
}
