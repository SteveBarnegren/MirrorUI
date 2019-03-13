//
//  Collection+Accessors.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 31/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

public extension Collection where Index == Int {
    
    subscript(maybe index: Int) -> Element? {
        
        if index > count - 1 {
            return nil
        } else if index < 0 {
            return nil
        } else {
            return self[index]
        }
    }
}
