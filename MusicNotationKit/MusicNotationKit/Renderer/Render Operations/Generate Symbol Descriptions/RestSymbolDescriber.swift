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
            fatalError("Whole note rests are not supported yet")
        case .eighth:
            fatalError("Whole note rests are not supported yet")
        case .sixteenth:
            fatalError("Whole note rests are not supported yet")
        }
        
        return description
    }
}
