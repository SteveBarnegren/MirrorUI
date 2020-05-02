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
        
        for (note, nextNote) in sequence.notes.eachWithNext() {
            if note.tiedToNext == false {
                continue
            }
            
            let tiedToNote: Note
            if let nextNote = nextNote {
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
        
        func pitchesAndNoteHeadDescriptions(for note: Note) -> [(Pitch, NoteHeadDescription)] {
            return Array(zip(note.pitches, note.noteHeadDescriptions)).sortedAscendingBy { $0.0 }
        }
        
        let start = pitchesAndNoteHeadDescriptions(for: startNote)
        let end = pitchesAndNoteHeadDescriptions(for: endNote)
        
        for ((startPitch, startHeadDescription), (endPitch, endHeadDescription)) in zip(start, end) {
            
            print("------------")
                                    
            let noteStavePosition = abs(startHeadDescription.stavePosition)
            
            var startPosition = TiePosition()
            var middlePosition = TiePosition()
            startPosition.sign = startNote.symbolDescription.stemDirection == .down ? .positive: .negative
            middlePosition.sign = startNote.symbolDescription.stemDirection == .down ? .positive: .negative
            
            if noteStavePosition.isEven {
                startPosition.lineNumber = noteStavePosition / 2
                startPosition.spaceQuartile = .threeQuarters
            } else {
                startPosition.lineNumber = (noteStavePosition-1)/2 + 1
                startPosition.spaceQuartile = .half
            }
            
            middlePosition.lineNumber = startPosition.lineNumber + 1
            middlePosition.spaceQuartile = .half
            
            print("Start line number: \(startPosition.lineNumber)")
            print("Start quartile: \(startPosition.spaceQuartile)")
            print("Middle line number: \(middlePosition.lineNumber)")
            print("Middle quartile: \(middlePosition.spaceQuartile)")
            
            let tie = Tie(orientation: .aboveNoteHead)
            tie.toNote = endNote
            tie.toNoteHead = endHeadDescription
            tie.startPosition = startPosition
            tie.middlePosition = middlePosition
            
            let startStavePosition = startHeadDescription.stavePosition
            let isOnLine = startStavePosition.isEven
            let endsOffset = isOnLine ? 1 : 2
            let middleOffset = endsOffset + 3
            
            
            

            //tie.endsStavePosition = startHeadDescription.stavePosition + endsOffset*sign
            //tie.middleStavePosition = startHeadDescription.stavePosition + middleOffset*sign
            startHeadDescription.tie = tie
        }
    }
    
    private func getStartNotes(ofBar bar: Bar) -> [Note] {
        return bar.sequences.compactMap { $0.notes.first }
    }
}

extension Sequence where Element: Equatable {
    
    func contains<T: Sequence>(anyOf other: T) -> Bool where T.Element == Element {
        return self.contains { (element) -> Bool in
            other.contains(element)
        }
    }
}
