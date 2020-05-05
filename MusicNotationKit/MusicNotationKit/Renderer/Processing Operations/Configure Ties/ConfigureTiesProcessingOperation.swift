//
//  ConfigureTiesProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class ConfigureTiesProcessingOperation: CompositionProcessingOperation {
    
    func process(composition: Composition) {
        composition.bars.eachWithNext().forEach(process)
    }
    
    private func process(bar: Bar, nextBar: Bar?) {
        
        let nextBarNotes = SingleValueCache<[Note]> {
            nextBar.flatMap(self.getStartNotes) ?? []
        }
        
        for sequence in bar.sequences {
            process(sequence: sequence, nextBarNotes: nextBarNotes)
        }
    }
    
    private func process(sequence: NoteSequence, nextBarNotes: SingleValueCache<[Note]>) {
        
        for (note, remaining) in sequence.notes.eachWithRemaining() {
            if note.tiedToNext == false {
                continue
            }
            
            let tiedToNote: Note
            if let nextNote = remaining.first(where: { $0.pitches.contains(anyOf: note.pitches) }) {
                tiedToNote = nextNote
            } else if let nextBarNote = nextBarNotes.value.first(where: { $0.pitches.contains(anyOf: note.pitches) }) {
                tiedToNote = nextBarNote
            } else {
                print("Error - Unable to find next tie end note")
                continue
            }
            
            createTie(between: note, and: tiedToNote)
        }
    }
    
    private func createTie(between startNote: Note, and endNote: Note) {
        
        func pitchesAndNoteHeadDescriptions(for note: Note) -> [(pitch: Pitch, description: NoteHeadDescription)] {
            return Array(zip(note.pitches, note.noteHeadDescriptions)).sortedAscendingBy { $0.0 }
        }
        
        let start = pitchesAndNoteHeadDescriptions(for: startNote)
        let end = pitchesAndNoteHeadDescriptions(for: endNote)
        
        for (startPitch, startHeadDescription) in start {
            
            let tie = makeTie(stavePosition: startHeadDescription.stavePosition,
                              stemDirection: startNote.symbolDescription.stemDirection)
            tie.toNote = endNote
            tie.toNoteHead = end.first { $0.pitch == startPitch }?.description
            startHeadDescription.tie = tie
        }
    }
    
    private func makeTie(stavePosition: Int, stemDirection: StemDirection) -> Tie {
        
        let isOnSpace = stavePosition.isOdd
        let tieAboveNote = (stemDirection == .down)
        let tieDirectionMultiplier = tieAboveNote ? 1 : -1
        
        // Start on the next available space
        var startSpace: StaveSpace
        let endAlignment: TieEndAlignment
        if isOnSpace {
            startSpace = StaveSpace(stavePosition: stavePosition,
                                    lineRounding: .spaceAbove).adding(spaces: tieDirectionMultiplier)
            endAlignment = .middleOfSpace
        } else {
            startSpace = StaveSpace(stavePosition: stavePosition,
                                    lineRounding: tieAboveNote ? .spaceAbove : .spaceBelow)
            endAlignment = tieAboveNote ? .sittingAboveNoteHead : .hangingBelowNoteHead
        }
        
        // Middle is one space above
        let middleSpace = startSpace.adding(spaces: tieDirectionMultiplier)
        
        let tie = Tie()
        tie.startPosition = TiePosition(space: startSpace)
        tie.middlePosition = TiePosition(space: middleSpace)
        tie.endAlignment = endAlignment
        
        return tie
    }
    
    private func getStartNotes(ofBar bar: Bar) -> [Note] {
        return bar.sequences.compactMap { $0.notes.first }
    }
    
    private func previousEven(_ value: Int) -> Int {
        if value.isEven {
            return value
        }
        
        if value > 0 {
            return value - 1
        } else {
            return value + 1
        }
    }
}
