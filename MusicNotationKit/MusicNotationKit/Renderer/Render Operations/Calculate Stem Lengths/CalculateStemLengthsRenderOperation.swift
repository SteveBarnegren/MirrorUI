//
//  CalculateStemLengthsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 24/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculateStemLengthsRenderOperation: RenderOperation {
    
    func process(composition: Composition, layoutWidth: Double) {
        composition.bars.forEach(process)
    }
    
    private func process(bar: Bar) {
        bar.sequences.forEach(process)
    }
    
    private func process(noteSequence: NoteSequence) {
        
        noteSequence
            .notes
            .clustered()
            .forEach(process)
    }
    
    private func process(noteCluster: [Note]) {
        
        noteCluster.forEach { $0.symbolDescription.stemLength = 3.5 }
        
        
        
        
        
        
        
        
    }
    
}


extension Array where Element == Note {
    
    func clustered() -> [[Note]] {
        
        var clusters = [[Note]]()
        
        var currentCluster = [Note]()
    
        func commit() {
            if currentCluster.isEmpty == false {
                clusters.append(currentCluster)
                currentCluster.removeAll()
            }
        }
        
        for note in self {
            
            if note.beams.isEmpty || note.beams.contains(.connectedNext) {
                commit()
            }
            currentCluster.append(note)
        }
        
        commit()
        return clusters
    }
}

