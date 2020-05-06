//
//  ConfigureTiesProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class ConfigureTiesProcessingOperation: CompositionProcessingOperation {
    
    private let tieCreator = TieCreator(transformer: .notes)
    
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
        
        let ties: [TieVariations] = tieCreator.createTies(between: startNote, and: endNote)
        
        for tieVariations in ties {
            guard let tie = tieVariations.ties.first else {
                assertionFailure("Expected at least one tie variation to be created")
                return
            }
            
            tie.toNote = endNote
            tie.toNoteHead = endNote.noteHeadDescriptions[tieVariations.endNoteHeadIndex]
            startNote.noteHeadDescriptions[tieVariations.startNoteHeadIndex].tie = tie
        }
    }
    
    private func getStartNotes(ofBar bar: Bar) -> [Note] {
        return bar.sequences.compactMap { $0.notes.first }
    }
}
