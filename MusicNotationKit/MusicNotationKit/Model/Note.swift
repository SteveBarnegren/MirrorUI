//
//  Note.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

public class Note {
    
    public enum Value {
        case whole
        case half
        case quarter
    }
    
    let value: Value
    public init(value: Value) {
        self.value = value
    }
}

public class Composition {
    
    var notes = [Note]()
    
    public init(notes: [Note]) {
        self.notes = notes
    }
    
    func add(note: Note) {
        notes.append(note)
    }
}
