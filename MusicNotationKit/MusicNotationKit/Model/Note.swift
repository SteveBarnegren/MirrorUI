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
    var leadingConstraint = HorizontalConstraint.zero
    var trailingConstraint = HorizontalConstraint.zero
    var trailingLayoutItems: [HorizontalLayoutItem] {
        return self.symbolDescription.trailingLayoutItems
    }
    
    var leadingLayoutOffset: Double {
        return self.leadingConstraint.minimumDistance(atPriority: .required)
    }
    
    var trailingLayoutOffset: Double {
        return self.trailingConstraint.minimumDistance(atPriority: .required)
    }
    
    // Positionable
    var position = Point.zero
    
    // Beamable
    var numberOfBeams: Int {
        return symbolDescription.numberOfBeams
    }
    
    var beams: [Beam] {
        get { return symbolDescription.beams }
        set { symbolDescription.beams = newValue }
    }
    
    // MARK: - Init
    public init(value: NoteValue, pitch: Pitch) {
        self.value = value
        self.pitch = pitch
    }
    
    var numberOfForwardBeamConnections: Int {
        var num = 0
        
        for beam in self.beams {
            if beam.style == .connectedToNext {
                num += 1
            }
        }
        
        return num
    }
}

struct Beam: Equatable {
    
    enum BeamStyle {
        case connectedToNext
        case cutOffLeft
        case cutOffRight
    }
    
    let style: BeamStyle
}

class NoteSymbolDescription {
    
    enum HeadStyle {
        case none
        case semibreve
        case open
        case filled
    }
    
    let headStyle: HeadStyle
    let hasStem: Bool
    var trailingLayoutItems = [HorizontalLayoutItem]()
    
    // Beamable
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
}
