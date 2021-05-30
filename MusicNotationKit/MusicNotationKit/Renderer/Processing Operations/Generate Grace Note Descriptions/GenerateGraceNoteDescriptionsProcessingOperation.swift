//
//  GenerateGraceNoteDescriptionsProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 30/05/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateGraceNoteDescriptionsProcessingOperation: CompositionProcessingOperation {

    func process(composition: Composition) {
        composition.forEachBar(process)
    }

    private func process(bar: Bar) {
        let clef = bar.clef
        bar.forEachNote {
            self.process(note: $0, clef: clef)
        }
    }

    private func process(note: Note, clef: Clef) {
        note.graceNotes.forEach {
            self.process(graceNote: $0, clef: clef)
        }
    }

    private func process(graceNote: GraceNote, clef: Clef) {
        graceNote.stavePosition = graceNote.pitch.stavePosition(forClef: clef)
    }
}
