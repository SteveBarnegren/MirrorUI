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
    let pitch: Pitch
    public init(value: Value, pitch: Pitch) {
        self.value = value
        self.pitch = pitch
    }
    
    var duration: Double {
        switch self.value {
        case .whole: return 1.0
        case .half: return 1.0 / 2
        case .quarter: return 1.0 / 4
        }
    }
}

public class Composition {
    
    var notes = [Note]()
    
    var duration: Double {
        return notes.reduce(0) { $0 + $1.duration }
    }
    
    public init(notes: [Note] = []) {
        self.notes = notes
    }
    
    public func add(note: Note) {
        notes.append(note)
    }
}
