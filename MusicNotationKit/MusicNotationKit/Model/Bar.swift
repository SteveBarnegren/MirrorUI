//
//  Bar.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public class Bar {
    
    var sequences = [NoteSequence]()
    let leadingBarline = Barline()
    var trailingBarline: Barline?
    public var timeSignature: TimeSignature?
    
    var duration: Time {
        return sequences.map { $0.duration }.max() ?? .zero
    }
    
    // Cached information
    var layoutAnchors = [LayoutAnchor]()
    var trailingBarlineAnchor: LayoutAnchor?
    var minimumWidth = Double(0)
    var preferredWidth = Double(0)
    
    public init() {}
    
    public func add(sequence: NoteSequence) {
        self.sequences.append(sequence)
    }
    
    func resetLayoutAnchors() {
        layoutAnchors.forEach { $0.reset() }
        trailingBarlineAnchor?.reset()
    }
}

extension Bar {
    
    func forEachNote(_ handler: (Note) -> Void) {
        for sequence in self.sequences {
            for note in sequence.notes {
                handler(note)
            }
        }
    }
}

extension Array where Element == Bar {
    
    func forEachNote(_ handler: (Note) -> Void) {
        
        for bar in self {
            bar.forEachNote(handler)
        }
    }
}
