//
//  Note.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

class Note {
    
    enum Value {
        case whole
        case half
        case quarter
        case eighth
        case sixteenth
        case thirtysecond
        case sixthFourth
    }
    
    let value: Value
    init(value: Value) {
        self.value = value
    }
}

class Composition {
    
    var notes = [Note]()
    
    func add(note: Note) {
        notes.append(note)
    }
}
