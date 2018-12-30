//
//  Array+Extensions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 30/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func append(maybe element: Element?) {
        if let element = element {
            append(element)
        }
    }
}
