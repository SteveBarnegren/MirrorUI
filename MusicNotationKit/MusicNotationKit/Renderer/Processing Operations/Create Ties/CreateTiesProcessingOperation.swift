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
                variation.value.startNoteTime = startNote.time
                variation.value.endNoteTime = endNote.time
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
        let variationSets = bar.sequences.map(self.variationSets).joined().toArray()
        
        let variationSelector = VariationSelector()
        variationSelector.add(conflictIdentifier: makeTiesConflictIdentifier())
        variationSelector.add(variationSets: variationSets)
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
    
    private func makeTiesConflictIdentifier() -> ConflictIdentifier<Tie, Tie> {
        return ConflictIdentifier<Tie, Tie>(areCompatible: self.areTiesCompatable)
    }
    
    private func areTiesCompatable(tie1: Tie, tie2: Tie) -> Bool {
        
        func makeVector(_ x: Time, _ y: TiePosition) -> Vector2D {
            return Vector2D(x.barPct,
                            Double(y.space.stavePosition))
        }
        
        func makeVectors(forTie tie: Tie) -> (start: Vector2D, middle: Vector2D, end: Vector2D) {
            return (
                makeVector(tie.startNoteTime, tie.startPosition),
                makeVector(tie.startNoteTime + ((tie.endNoteTime - tie.startNoteTime)/2), tie.middlePosition),
                makeVector(tie.endNoteTime, tie.startPosition)
            )
        }
        
        func does(_ p1: Vector2D, _ p2: Vector2D, intersectWith p3: Vector2D, _ p4: Vector2D) -> Bool {
            return VectorMath.lineSegmentsIntersect(start1: p1, end1: p2, start2: p3, end2: p4)
        }
        
        print("Tie compatability -------------")
        
        let t1 = makeVectors(forTie: tie1)
        let t2 = makeVectors(forTie: tie2)
        print("t1 s: (\(t1.start.x), \(t1.start.y))")
        print("t1 m: (\(t1.middle.x), \(t1.middle.y))")
        print("t1 e: (\(t1.end.x), \(t1.end.y))")
        
        print("t2 s: (\(t2.start.x), \(t2.start.y))")
        print("t2 m: (\(t2.middle.x), \(t2.middle.y))")
        print("t2 e: (\(t2.end.x), \(t2.end.y))")
        
        for v1 in [t1.start, t1.middle, t1.end] {
            for v2 in [t2.start, t2.middle, t2.end] {
                if v1 == v2 {
                    print("Ties contain same point")
                    return false
                }
            }
        }
        
        if does(t1.start, t1.middle, intersectWith: t2.start, t2.middle) {
            print("First halves intersect")
            return false
        }
        if does(t1.start, t1.middle, intersectWith: t2.middle, t2.end) {
            print("t1 first half intersect t2 second half")
            return false
        }
        if does(t1.middle, t1.end, intersectWith: t2.start, t2.middle) {
            print("t1 second half intersect t2 first half")
            return false
        }
        if does(t1.middle, t1.end, intersectWith: t2.middle, t2.end) {
            print("Second halves intersect")
            return false
        }
        
        
        print("Compatible")
        return true
    }
}
