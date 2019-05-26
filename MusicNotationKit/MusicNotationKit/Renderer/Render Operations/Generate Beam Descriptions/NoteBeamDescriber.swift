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
            if beam == .connectedToNext {
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
        
        var lastNumberOfForwardConnections = 0
        
        for (index, item) in noteCluster.enumerated() {
            var beamsLeft = beaming.numberOfBeams(item) 
            
            // forward beam connections
            var numberOfForwardBeams = 0
            if let next = noteCluster[maybe: index+1] {
                numberOfForwardBeams = min(beaming.numberOfBeams(item), beaming.numberOfBeams(next))
            }
            var noteBeams: [Beam] = (0..<numberOfForwardBeams).map { _ in Beam.connectedToNext }
            
            // Remove accounted for beams by forward or backward connections
            beamsLeft -= max(lastNumberOfForwardConnections, numberOfForwardBeams)

            // Add remaining beams as cut-offs
            while beamsLeft > 0 {
                let beam: Beam = (index == noteCluster.count - 1) ? .cutOffLeft : .cutOffRight
                noteBeams.append(beam)
                beamsLeft -= 1
            }

            beaming.setBeams(item, noteBeams)
            lastNumberOfForwardConnections = noteBeams.numberOfForwardBeamConnections
        }
    }
}
