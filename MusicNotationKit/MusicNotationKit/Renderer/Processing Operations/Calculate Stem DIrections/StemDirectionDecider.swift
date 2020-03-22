//
//  StemDirectionDecider.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class StemDirectionDecider<N> {
    
    struct Transformer<N> {
        let stavePositions: (N) -> [Int]
        let setStemDirection: (N, StemDirection) -> Void
    }
    
    let tf: Transformer<N>
    
    init(transformer: Transformer<N>) {
        self.tf = transformer
    }
    
    func process(noteCluster notes: [N]) {
        
        // Work out the direction for this cluster
        var numDown = 0
        var numUp = 0
        var furthestDistanceFromCenter = -1
        var furthestFromCenterDirection = StemDirection.down
        
        for note in notes {
            let stavePosition = self.stavePosition(forNote: note)
            let distanceFromCenter = abs(stavePosition)
            let direction: StemDirection
            if stavePosition < 0 {
                numUp += 1
                direction = .up
            } else {
                numDown += 1
                direction = .down
            }
            
            if distanceFromCenter > furthestDistanceFromCenter {
                furthestDistanceFromCenter = distanceFromCenter
                furthestFromCenterDirection = direction
            } else if distanceFromCenter == furthestDistanceFromCenter && direction == .down {
                furthestFromCenterDirection = .down
            }
        }
        
        let direction: StemDirection
        if numUp > numDown {
            direction = .up
        } else if numDown > numUp {
            direction = .down
        } else {
            direction = furthestFromCenterDirection
        }
       
        // Apply stem direction to notes
        notes.forEach { tf.setStemDirection($0, direction) }
    }
    
    private func stavePosition(forNote note: N) -> Int {
        
        let stavePositions = tf.stavePositions(note)
        assert(stavePositions.count > 0, "Notes should at least have one stave position")
        
        // Single stave position
        if stavePositions.count == 1 {
            return stavePositions[0]
        }
        // Multiple stave positions - return the position that is furthest from the centre.
        // If pitches are equidistant from then the pitch above the centre line (with a
        // downwards stem) wins.
        else {
            return stavePositions.max(by: { p1, p2 in
                let p1FromCentre = abs(p1)
                let p2FromCentre = abs(p2)
                if p1FromCentre > p2FromCentre {
                    return false
                } else if p2FromCentre > p1FromCentre {
                    return true
                } else {
                    return p1 >= 0 ? false : true
                }
            })!
        }
    }
}

// MARK: - Notes Transformer

extension StemDirectionDecider.Transformer {
    
    static var notes: StemDirectionDecider.Transformer<Note> {
        return StemDirectionDecider.Transformer<Note>(stavePositions: { n in n.pitches.map { $0.stavePosition } },
                                                      setStemDirection: { $0.symbolDescription.stemDirection = $1 })
    }
}
