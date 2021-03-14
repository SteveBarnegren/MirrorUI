//
//  Composition.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public class Composition {
    
    var isPreprocessed = false
    
    var bars = [Bar]()
    
    var notes: [Note] {
        return bars.map { $0.sequences }.joined().map { $0.notes }.joined().toArray()
    }
    
    var numberOfBars: Int {
        return bars.count
    }
    
    var duration: Time {
        return bars.reduce(Time.zero) { $0 + $1.duration }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Add bars
    
    public func add(bar: Bar) {
        self.bars.append(bar)
    }
    
    // MARK: - Enumeration conviniences
    
    func forEachNote(_ handler: (Note) -> Void) {
        
        for bar in bars {
            for noteSequence in bar.sequences {
                for note in noteSequence.notes {
                    handler(note)
                }
            }
        }
    }
    
    func forEachRest(_ handler: (Rest) -> Void) {
        
        for bar in bars {
            for noteSequence in bar.sequences {
                for rest in noteSequence.rests {
                    handler(rest)
                }
            }
        }
    }
    
    func forEachNoteSequence(_ handler: (NoteSequence) -> Void) {
        
        for bar in bars {
            for noteSequence in bar.sequences {
                handler(noteSequence)
            }
        }
    }
    
    func forEachBar(_ handler: (Bar) -> Void) {
        for bar in bars {
            handler(bar)
        }
    }
}
