//
//  Stave.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 14/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

public class Stave {
    
    var clef = Clef.treble
    var bars = [Bar]()
    
    var duration: Time {
        return bars.reduce(Time.zero) { $0 + $1.duration }
    }
    
    public init() {}
    
    public func add(bar: Bar) {
        self.bars.append(bar)
    }
    
    func forEachNote(_ handler: (Note) -> Void) {
        
        for bar in bars {
            for noteSequence in bar.sequences {
                for note in noteSequence.notes {
                    handler(note)
                }
            }
        }
        
    }
}
