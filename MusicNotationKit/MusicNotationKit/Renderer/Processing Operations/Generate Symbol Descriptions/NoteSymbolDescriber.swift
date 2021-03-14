//
//  Symbolizer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteSymbolDescriber {
    
    struct Result {
        let hasStem: Bool
        let numberOfTails: Int
    }
    
    func symbolDescription(forNote note: Note) -> Result {
        
        let hasStem: Bool
        let numberOfTails: Int
        
        switch note.value.division {
        case 1:
            hasStem = false
            numberOfTails = 0
        case 2:
            hasStem = true
            numberOfTails = 0
        case 4:
            hasStem = true
            numberOfTails = 0
        default:
            hasStem = true
            numberOfTails = self.numberOfTails(forDivision: note.value.division)
        }
        
        return Result(hasStem: hasStem, numberOfTails: numberOfTails)
    }
    
    private func numberOfTails(forDivision division: Int) -> Int {
        
        switch division {
        case 1: return 0
        case 2: return 0
        case 4: return 0
        case 8: return 1
        case 16: return 2
        case 32: return 3
        case 64: return 4
        case 128: return 5
        case 256: return 6
        case 512: return 7
        case 1024: return 8
        case 2048: return 9
        case 4096: return 10
        case 8192: return 11
        default:
            fatalError("division \(division) not supported!")
        }
    }
}
