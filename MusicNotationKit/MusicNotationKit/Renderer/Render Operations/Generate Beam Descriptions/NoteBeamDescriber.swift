//
//  NoteBeamDescriber.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

struct Beaming<T> {
    
    // Inputs
    var time: (T) -> Time
    var numberOfTails: (T) -> Int
    
    // Outputs
    var setBeams: (T, [Beam]) -> Void
}

extension Beaming where T == Note {
    
    static var notes: Beaming<Note> {
        return Beaming(time: { return $0.time },
                       numberOfTails: { return $0.symbolDescription.numberOfTails },
                       setBeams: { note, beams in note.beams = beams})
    }
}

class NoteBeamDescriber<T> {
    
    let beaming: Beaming<T>
    
    init(beaming: Beaming<T>) {
        self.beaming = beaming
    }
    
    func applyBeams(to notes: [T]) {
        
        let notesByBeat = notes.chunked(atChangeTo: { beaming.time($0).convertedTruncating(toDivision: 4).value })
        notesByBeat.forEach { applyBeams(toNoteCluster: $0) }
    }

    private func applyBeams(toNoteCluster noteCluster: [T]) {
        
        // Don't apply beams to a single note
        if noteCluster.count == 1 {
            return
        }
        
        var prevNumberOfBeams = 0
        
        for (noteIndex, item) in noteCluster.enumerated() {
            let numberOfBeams = beaming.numberOfTails(item)
            
            var nextNumberOfBeams = Int(0)
            if let next = noteCluster[maybe: noteIndex+1] {
                nextNumberOfBeams = beaming.numberOfTails(next)
            }
            
            var beams = [Beam]()
            for beamIndex in 0..<numberOfBeams {
                if beamIndex < prevNumberOfBeams && beamIndex < nextNumberOfBeams {
                    beams.append(.connectedBoth)
                } else if beamIndex < prevNumberOfBeams {
                    beams.append(.connectedPrevious)
                } else if beamIndex < nextNumberOfBeams {
                    beams.append(.connectedNext)
                } else if noteIndex == noteCluster.count-1 {
                    beams.append(.cutOffLeft)
                } else {
                    beams.append(.cutOffRight)
                }
            }
            
            beaming.setBeams(item, beams)
            prevNumberOfBeams = numberOfBeams
        }
    }
}
