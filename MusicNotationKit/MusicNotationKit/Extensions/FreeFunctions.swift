//
//  FreeFunctions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 16/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public func repeated(times: Int, handler: () -> Void) {
    if times <= 0 {
        return
    }
    
    for _ in (0..<times) {
        handler()
    }
}
