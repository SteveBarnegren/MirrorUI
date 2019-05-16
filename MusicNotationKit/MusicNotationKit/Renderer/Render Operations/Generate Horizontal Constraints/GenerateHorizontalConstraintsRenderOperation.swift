//
//  GenerateNoteConstraintsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateHorizontalConstraintsRenderOperation: RenderOperation {
    
    private let noteConstraintsDescriber = NoteConstraintsDescriber()
    private let restConstraintsDescriber = RestConstraintsDescriber()
    private let dotConstraintsDescriber = DotConstraintsDescriber()
    
    func process(composition: Composition, layoutWidth: Double) {
        composition.enumerateNotes { note in
            noteConstraintsDescriber.process(note: note)
            note.symbolDescription.trailingSymbols.forEach(addConstraints)
        }
        composition.enumerateRests(restConstraintsDescriber.process)
    }
    
    private func addConstraints(toSymbol symbol: HorizontalLayoutItem) {
        
        switch symbol {
        case let dot as DotSymbol:
            dotConstraintsDescriber.process(dotSymbol: dot)
        default:
            fatalError("Unknown symbol type: \(symbol)")
        }
    }
}
