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
    var duration: (T) -> Time
    var time: (T) -> Time
    var numberOfTails: (T) -> Int
    
    // Outputs
    var setBeams: (T, [Beam]) -> Void
}

extension Beaming where T == Note {
    
    static var notes: Beaming<Note> {
        return Beaming(duration: { return $0.duration },
                       time: { return $0.time },
                       numberOfTails: { return $0.symbolDescription.numberOfTails },
                       setBeams: { note, beams in note.beams = beams})
    }
}

class NoteBeamDescriber<T> {
    
    let beaming: Beaming<T>
    
    init(beaming: Beaming<T>) {
        self.beaming = beaming
    }
    
    func applyBeams(to notes: [T], timeSignature: TimeSignature = TimeSignature(value: 4, division: 4)) {
        
        let clusters = notes.chunked(atChangeTo: { beaming.time($0).convertedTruncating(toDivision: timeSignature.division).value })
        var popper = ElementPopper(array: clusters)
        
        while let cluster = popper.popNext() {

            var extendedCluster = cluster
            if canClusterSupportExtendedBeaming(extendedCluster, timeSignature: timeSignature) {
                while let nextCluster = popper.next(),
                    canClustersSupportExtendedBeaming(extendedCluster, nextCluster, timeSignature: timeSignature) {
                        extendedCluster += nextCluster
                        popper.popNext()
                }
                applyBeams(toNoteCluster: extendedCluster, timeSignature: timeSignature)
            } else {
                applyBeams(toNoteCluster: cluster, timeSignature: timeSignature)
            }
        }
    }
    
    private func canClusterSupportExtendedBeaming(_ cluster: [T], timeSignature: TimeSignature) -> Bool {
        
        guard let firstNote = cluster.first else {
            return false
        }
        
        let duration = beaming.duration(firstNote)
        guard timeSignature.allowsExtendedBeaming(forDuration: duration) else {
            return false
        }
        
        var totalClusterTime = duration
        for note in cluster.dropFirst() {
            if beaming.duration(note) != duration {
                return false
            }
            totalClusterTime += duration
        }
        
        return totalClusterTime == timeSignature.beatDuration
    }
    
    private func canClustersSupportExtendedBeaming(_ cluster: [T],
                                                   _ additionalCluster: [T],
                                                   timeSignature: TimeSignature) -> Bool {
        
        guard let firstNote = cluster.first else {
            return false
        }
        let noteDuration = beaming.duration(firstNote)
        
        if additionalCluster.allSatisfy({ beaming.duration($0) == noteDuration }) == false {
            return false
        }
        
        guard let lastNote = additionalCluster.last else {
            return false
        }
        
        let start = beaming.time(firstNote)
        let end = beaming.time(lastNote)
        
        for beamBreak in timeSignature.beamBreaks() {
           
            if end < beamBreak {
                break
            }
            
            if start < beamBreak && end >= beamBreak {
                return false
            }
        }
        
        return true
    }
    
    private func applyBeams(toNoteCluster noteCluster: [T], timeSignature: TimeSignature) {
        
        // Don't apply beams to a single note
        if noteCluster.count == 1 {
            return
        }
        
        var prevNumberOfBeams = 0
        var carriedOverBeams = 0
        
        for (noteIndex, item) in noteCluster.enumerated() {
            let numberOfBeams = beaming.numberOfTails(item)
            
            var nextNumberOfBeams = Int(0)
            var beamsToCarryOver = 0
            if let next = noteCluster[maybe: noteIndex+1] {
                nextNumberOfBeams = beaming.numberOfTails(next)
                if numberOfBeams == nextNumberOfBeams {
                    let num = numberOfBeamsBetweenSameDurationNotes(first: item, second: next, timeSignature: timeSignature)
                    beamsToCarryOver = nextNumberOfBeams - num
                    nextNumberOfBeams = num
                }
            }
            
            prevNumberOfBeams -= carriedOverBeams
            
            var beams = [Beam]()
            for beamIndex in 0..<(numberOfBeams) {
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
            carriedOverBeams = beamsToCarryOver
        }
    }
    
    private func numberOfBeamsBetweenSameDurationNotes(first: T, second: T, timeSignature: TimeSignature) -> Int {
        
        assert(beaming.numberOfTails(first) == beaming.numberOfTails(second))
        assert(beaming.duration(first) == beaming.duration(second))
        
        var numberOfBeams = beaming.numberOfTails(first)
        let duration = beaming.duration(first)
        
        let firstTime = beaming.time(first)
        let secondTime = beaming.time(second)
        
        var division = duration.division
        division /= 2
        
        while division >= 16
            && firstTime.convertedTruncating(toDivision: division/2) != secondTime.convertedTruncating(toDivision: division/2) {
            numberOfBeams -= 1
            division /= 2
        }
        
        return numberOfBeams
    }
}
