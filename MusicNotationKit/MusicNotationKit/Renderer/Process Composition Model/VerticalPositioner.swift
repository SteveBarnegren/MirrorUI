//
//  VerticalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class VerticalPositioner {
    
    func process(composition: Composition) {
        composition.enumerateNotes { self.position(note: $0) }
    }
    
    func position(note: Note) {
        note.position.y = note.pitch.staveOffset - 0.5
    }

}
