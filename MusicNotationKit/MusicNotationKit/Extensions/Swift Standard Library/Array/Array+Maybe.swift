//
//  Array+Maybe.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public extension Array {
    
    mutating func append(maybe item: Element?) {
        
        if let item = item {
            append(item)
        }
    }
    
    func appending(maybe item: Element?) -> [Element] {
        
        if let item = item {
            return appending(item)
        } else {
            return self
        }
    }
}
