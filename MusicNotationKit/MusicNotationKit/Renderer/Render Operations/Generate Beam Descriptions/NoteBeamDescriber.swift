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
            print("-> NEW CLUSTER")

            var extendedCluster = cluster
            print("Cluster count: \(extendedCluster.count)")
            if canClusterSupportExtendedBeaming(extendedCluster, timeSignature: timeSignature) {
                print("Supports extended")
                while let nextCluster = popper.next(),
                    canClustersSupportExtendedBeaming(extendedCluster, nextCluster, timeSignature: timeSignature) {
                        print("Next cluster can extend")
                        extendedCluster += nextCluster
                        popper.popNext()
                        print("new count: \(extendedCluster.count)")
                }
                print("Apply beams (count: \(extendedCluster.count))")
                applyBeams(toNoteCluster: extendedCluster, timeSignature: timeSignature)
            } else {
                print("Apply beams (count: \(extendedCluster.count))")
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
        
        //print("**********************************")
        for beamBreak in timeSignature.beamBreaks() {
            print("-------")
            print("Start: \(start)")
            print("End: \(end)")
            print("Break: \(beamBreak)")
            
            if end < beamBreak {
              
                break
            }
            
            if start < beamBreak && end >= beamBreak {
                print("false")
                print("-------")
                return false
            }
        }
        
        print("true")
        print("-------")
        return true
    }
    
    private func applyBeams(toNoteCluster noteCluster: [T], timeSignature: TimeSignature) {
        
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
