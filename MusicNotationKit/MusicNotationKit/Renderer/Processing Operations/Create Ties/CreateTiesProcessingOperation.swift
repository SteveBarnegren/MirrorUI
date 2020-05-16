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
                variation.value.fromNote = startNote
                variation.value.fromNoteHead = startNote.noteHeadDescriptions[tieVariations.startNoteHeadIndex]
                variation.value.toNote = endNote
                variation.value.toNoteHead = endNote.noteHeadDescriptions[tieVariations.endNoteHeadIndex]
                variation.value.startNoteTime = startNote.compositionTime
                variation.value.endNoteTime = endNote.compositionTime
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
        
        var barsToProcess = [Bar]()
        
        func processBars() {
            self.chooseVariations(forBars: barsToProcess)
            barsToProcess.removeAll()
        }
        
        for bar in composition.bars {
            barsToProcess.append(bar)
            if doesBarContainTiesToNextBar(bar: bar) == false {
                processBars()
            }
        }
        
        processBars()
    }
    
    private func doesBarContainTiesToNextBar(bar: Bar) -> Bool {
        
        for sequence in bar.sequences {
            for note in sequence.notes {
                for noteHead in note.noteHeadDescriptions {
                    if let tie = noteHead.tie?.chosenVariation {
                        if tie.startNoteTime.bar != tie.endNoteTime.bar {
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }

    private func chooseVariations(forBars bars: [Bar]) {
        
        let tieVariationSets = bars.map { $0.sequences }.joined()
            .map(self.variationSets).joined()
            .toArray()
        
        let notes = bars.map { $0.sequences }.joined()
            .map { $0.notes }.joined().toArray()
        
        let variationSelector = VariationSelector()
        variationSelector.add(conflictIdentifier: ConflictIdentifiers.ties)
        variationSelector.add(conflictIdentifier: ConflictIdentifiers.tiesAndNotes)
        variationSelector.add(variationSets: tieVariationSets)
        variationSelector.add(staticItems: notes)
        variationSelector.pruneVariations()
    }
    
    private func variationSets(forNoteSequence noteSequence: NoteSequence) -> [VariationSet<Tie>] {
        
        var variationSets = [VariationSet<Tie>]()
        
        for note in noteSequence.notes {
            for noteHead in note.noteHeadDescriptions {
                variationSets.append(maybe: noteHead.tie)
            }
        }
        
        return variationSets
    }
}
