//
//  Array+EachWith.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

extension Array {
    
    func eachWithPrevious() -> [(Element, Element?)] {
        
        var array = [(Element, Element?)]()
        var previousItem: Element?
        
        for item in self {
            array.append((item, previousItem))
            previousItem = item
        }
        
        return array
    }
}

extension Array {
    
    func eachWithNext() -> [(Element, Element?)] {
        
        var array = [(Element, Element?)]()
        
        for (index, item) in self.enumerated() {
            array.append((item, self[maybe: index+1]))
        }
        
        return array
    }
}

