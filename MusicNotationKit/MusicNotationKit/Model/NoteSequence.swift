//
//  NoteSequence.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public class NoteSequence {
    
    var playables = [Playable]()
    var notes: [Note] {
        return playables.compactMap { $0 as? Note }
    }
    var rests: [Rest] {
        return playables.compactMap { $0 as? Rest }
    }
    var ties: [VariationSet<Tie>] {
        return notes.map { note in
            note.noteHeadDescriptions.compactMap { $0.tie }
        }.joined().toArray()
    }
    
    var duration: Time {
        return playables.reduce(Time.zero) { $0 + $1.duration }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Add Playable items
    
    public func add(note: Note) {
        self.playables.append(note)
    }
    
    public func add(rest: Rest) {
        self.playables.append(rest)
    }
}
