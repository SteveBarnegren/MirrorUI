//
//  CalculateStemDirectionsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 13/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculateStemDirectionsRenderOperation: RenderOperation {
    
    private var isFirstNote = true
    
    func process(composition: Composition, layoutWidth: Double) {
        
        isFirstNote = true
        composition.enumerateNotes(calculateStemDirection)
    }
    
    private func calculateStemDirection(forNote note: Note) {
        
        note.symbolDescription.stemDirection = isFirstNote ? .up : .up
        isFirstNote = false
    }
}
