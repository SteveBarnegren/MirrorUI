//
//  CreateTiesProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class CreateTiesProcessingOperation: CompositionProcessingOperation {
    
    private let tieCreator = TieCreator(transformer: .notes)
    
    func process(composition: Composition) {
        createTies(forComposition: composition)
        chooseVariations(forComposition: composition)
    }
    
    // MARK: - Create ties
    
    private func createTies(forComposition composition: Composition) {
        composition.bars.eachWithNext().forEach(createTies)
    }
    
    private func createTies(bar: Bar, nextBar: Bar?) {
        
        let nextBarNotes = SingleValueCache<[Note]> {
            nextBar.flatMap(self.getStartNotes) ?? []
        }
        
        for sequence in bar.sequences {
            createTies(sequence: sequence, nextBarNotes: nextBarNotes)
        }
    }
    
    private func createTies(sequence: NoteSequence, nextBarNotes: SingleValueCache<[Note]>) {
        
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
        
        let variationsArray: [TieVariations] = tieCreator.createTies(between: startNote, and: endNote)
        
        for tieVariations in variationsArray {
            var ties = [Variation<Tie>]()
            for variation in tieVariations.variations {
                variation.value.toNote = endNote
                variation.value.toNoteHead = endNote.noteHeadDescriptions[tieVariations.endNoteHeadIndex]
                ties.append(variation)
            }
            
            let variationSet = VariationSet<Tie>(variations: ties)
            startNote.noteHeadDescriptions[tieVariations.startNoteHeadIndex].tie = variationSet
        }
    }
    
    private func getStartNotes(ofBar bar: Bar) -> [Note] {
        return bar.sequences.compactMap { $0.notes.first }
    }
    
    // MARK: - Choose Tie Variations
    
    private func chooseVariations(forComposition composition: Composition) {
        composition.bars.forEach(chooseVariations)
    }
    
    private func chooseVariations(forBar bar: Bar) {
        bar.sequences.forEach(chooseVariations)
    }
    
    private func chooseVariations(forNoteSequence noteSequence: NoteSequence) {
        
        var variationSets = [VariationSet<Tie>]()
        
        for note in noteSequence.notes {
            for noteHead in note.noteHeadDescriptions {
                variationSets.append(maybe: noteHead.tie)
            }
        }
        
        let variationSelector = VariationSelector<Tie>()
        variationSelector.pruneVariations(variationSets: variationSets,
                                          areCompatable: areTiesCompatable)
    }
    
    private func areTiesCompatable(tie1: Tie, Tie2: Tie) -> Bool {
        return true
    }
}
