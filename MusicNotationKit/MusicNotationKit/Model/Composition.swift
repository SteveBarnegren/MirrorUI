//
//  Composition.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public class Composition {
    
    var bars = [Bar]()
    
    var numberOfBars: Int {
        return bars.count
    }
    
    var duration: Time {
        return bars.reduce(Time.zero) { $0 + $1.duration }
    }
    
    public init() {}
    
    public func add(bar: Bar) {
        self.bars.append(bar)
    }
    
    // MARK: - Enumeration conviniences
    
    func enumerateNotes(_ handler: (Note) -> Void) {
        
        for bar in bars {
            for noteSequence in bar.sequences {
                for note in noteSequence.notes {
                    handler(note)
                }
            }
        }
    }
    
    func enumerateNoteSequences(_ handler: (NoteSequence) -> Void) {
        
        for bar in bars {
            for noteSequence in bar.sequences {
                handler(noteSequence)
            }
        }
    }
}
