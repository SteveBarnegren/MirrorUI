//
//  Note.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

class Bar {
    var notes = [Note]()
    
    var duration: Double {
        return notes.reduce(0) { $0 + $1.duration }
    }
}

public class Note {
    
    public enum Value {
        case whole
        case half
        case quarter
        case eighth
        case sixteenth
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
        case .eighth: return 1.0 / 8
        case .sixteenth: return 1.0 / 16
        }
    }
}

public class Composition {
    
    var bars = [Bar]()
    
    var duration: Double {
        return bars.reduce(0) { $0 + $1.duration }
    }
    
    public init() {
    }
    
    // MARK: - Add Items
    
    public func add(note: Note, toBar barIndex: Int) {
        
        while bars.count <= barIndex {
            bars.append(Bar())
        }
        
        bars[barIndex].notes.append(note)
    }
}
