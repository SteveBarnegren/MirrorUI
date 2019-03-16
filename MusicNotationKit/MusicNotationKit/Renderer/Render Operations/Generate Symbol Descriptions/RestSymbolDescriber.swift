//
//  RestSymbolDescriber.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class RestSymbolDescriber {
    
    func symbolDescription(forRest rest: Rest) -> RestSymbolDescription {
        
        let description: RestSymbolDescription
        
        let division = rest.value.division
        switch division {
        case 1:
            fatalError("Whole note rests are not supported yet")
        case 2:
            description = RestSymbolDescription(style: .minim)
        case 4:
            description = RestSymbolDescription(style: .crotchet)
        default:
            var value = 8
            var tails = 1
            while value != division {
                value += value
                tails += 1
                
                if value > division {
                    fatalError("Unsupported division \(division)")
                }
            }
            
            let tailedRest = TailedRestStyle(numberOfTails: tails)
            description = RestSymbolDescription(style: .tailed(tailedRest))
        }
        
        return description
    }
}
