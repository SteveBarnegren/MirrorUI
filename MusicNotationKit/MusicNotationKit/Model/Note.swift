//
//  Note.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

public class Note: Playable {
    
    let pitch: Pitch
    var symbolDescription = NoteSymbolDescription.standard
    
    // Width
    var leadingWidth = Double(0)
    var trailingWidth = Double(0)
    var layoutDuration: Time? {
        return self.duration
    }
    
    // Playable
    let value: NoteValue
    var time = Time.zero
    
    // HorizontallyConstrained
    var leadingConstraints = [HorizontalConstraint]()
    var trailingConstraints = [HorizontalConstraint]()
    
    // Positionable
    var position = Point.zero
    
    // MARK: - Init
    
    public init(value: NoteValue, pitch: Pitch) {
        self.value = value
        self.pitch = pitch
    }
}

class NoteSymbolDescription {
    
    enum HeadStyle {
        case none
        case semibreve
        case open
        case filled
    }
    
    enum BeamStyle {
        case connectedToNext
        case cutOffLeft
        case cutOffRight
    }
    
    struct Beam {
        let index: Int
        let style: BeamStyle
    }
    
    let headStyle: HeadStyle
    let hasStem: Bool
    let numberOfBeams: Int
    var beams = [Beam]()
    
    init(headStyle: HeadStyle, hasStem: Bool, numberOfBeams: Int) {
        self.headStyle = headStyle
        self.hasStem = hasStem
        self.numberOfBeams = numberOfBeams
    }
    
    static var standard: NoteSymbolDescription {
        return NoteSymbolDescription(headStyle: .none, hasStem: false, numberOfBeams: 0)
    }
    
    var numberOfForwardBeamConnections: Int {
        
        var num = 0
        
        for beam in beams {
            if beam.style == .connectedToNext {
                num += 1
            }
        }
        
        return num
    }
}
