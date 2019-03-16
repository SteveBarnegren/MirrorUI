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
        
        switch rest.value {
        case .whole:
            fatalError("Whole note rests are not supported yet")
        case .half:
            description = RestSymbolDescription(style: .minim)
        case .quarter:
            description = RestSymbolDescription(style: .crotchet)
        case .eighth:
            let tailedRest = TailedRest(numberOfTails: 1)
            description = RestSymbolDescription(style: .tailed(tailedRest))
        case .sixteenth:
            let tailedRest = TailedRest(numberOfTails: 2)
            description = RestSymbolDescription(style: .tailed(tailedRest))
        }
        
        return description
    }
}
