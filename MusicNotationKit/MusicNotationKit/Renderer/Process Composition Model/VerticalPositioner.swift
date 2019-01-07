//
//  VerticalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class VerticalPositioner {
    
    func process(composition: Composition, staveCenterY: Double) {
        composition.enumerateNotes { self.position(note: $0, staveCenterY: staveCenterY) }
    }
    
    func position(note: Note, staveCenterY: Double) {
        
        let yOffset = Double(note.pitch.staveOffset)/2
        note.position.y = staveCenterY + yOffset - 0.5
    }

}
