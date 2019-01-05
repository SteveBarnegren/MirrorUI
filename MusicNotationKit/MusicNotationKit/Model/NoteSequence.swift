//
//  NoteSequence.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public class NoteSequence {
    var notes = [Note]()
    
    var duration: Time {
        return notes.reduce(Time.zero) { $0 + $1.duration }
    }
    
    public init() {}
    
    public func add(note: Note) {
        self.notes.append(note)
    }
}
