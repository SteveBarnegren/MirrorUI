//
//  Note.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

enum CompositionItem {
    case note(Note)
    case barline

    var duration: Double {
        switch self {
        case .note(let note):
            return note.duration
        case .barline:
            return 0
        }
    }
}

public class Note {
    
    public enum Value {
        case whole
        case half
        case quarter
        case eighth
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
        }
    }
}

public class Composition {
    
    var items = [CompositionItem]()
    
    var duration: Double {
        return items.reduce(0) { $0 + $1.duration }
    }
    
    public init() {
    }
    
    // MARK: - Add Items
    
    public func add(note: Note) {
        items.append(.note(note))
    }
    
    public func addBarline() {
        items.append(.barline)
    }
}
