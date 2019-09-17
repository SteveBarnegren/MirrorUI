//
//  Array+EachWith.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

extension Array {
    
    public func eachWithPrevious() -> [(Element, Element?)] {
        
        var array = [(Element, Element?)]()
        var previousItem: Element?
        
        for item in self {
            array.append((item, previousItem))
            previousItem = item
        }
        
        return array
    }
}
