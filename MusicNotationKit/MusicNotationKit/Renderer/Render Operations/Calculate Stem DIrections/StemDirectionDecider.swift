//
//  StemDirectionDecider.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class StemDirectionDecider {
    
    func process(noteCluster notes: [Note]) {
        
        // Work out the direction for this cluster
        var direction = StemDirection.up
        
        var numDownResults = 0
        for note in notes {
            let d = preferredStemDirection(for: note.pitch)
            if d == .down {
                numDownResults += 1
                if numDownResults > notes.count/2 {
                    direction = .down
                    break
                }
            }
        }
       
        // Apply stem direction to notes
        notes.forEach { $0.symbolDescription.stemDirection = direction }
    }
    
    private func preferredStemDirection(for pitch: Pitch) -> StemDirection {
        return pitch.staveOffset > 0 ? .down : .up
    }
}
