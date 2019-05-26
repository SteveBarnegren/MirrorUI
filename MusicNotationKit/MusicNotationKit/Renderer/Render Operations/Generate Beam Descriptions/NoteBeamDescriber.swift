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
    var numberOfBeams: (T) -> Int
    var beams: (T) -> [Beam]
    
    // Outputs
    var setBeams: (T, [Beam]) -> Void
}

extension Beaming where T == Note {
    
    static var notes: Beaming<Note> {
        return Beaming(time: { return $0.time },
                       numberOfBeams: { return $0.numberOfBeams  },
                       beams: { return $0.beams },
                       setBeams: { note, beams in note.beams = beams})
    }
}

extension Array where Element == Beam {
    var numberOfForwardBeamConnections: Int {
        var num = 0
        
        for beam in self {
            if beam == .connectedNext {
                num += 1
            }
        }
        
        return num
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
            let numberOfBeams = beaming.numberOfBeams(item)
            
            var nextNumberOfBeams = Int(0)
            if let next = noteCluster[maybe: noteIndex+1] {
                nextNumberOfBeams = beaming.numberOfBeams(next)
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
