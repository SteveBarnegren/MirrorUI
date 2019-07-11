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
    public var accidental = Accidental.none
    var symbolDescription = NoteSymbolDescription.standard
    
    // Width
    var layoutDuration: Time? {
        return self.duration
    }
    
    // Playable
    let value: NoteValue
    var time = Time.zero
    
    var leadingLayoutItems: [AdjacentLayoutItem] {
        return self.symbolDescription.leadingLayoutItems
    }
    var trailingLayoutItems: [AdjacentLayoutItem] {
        return self.symbolDescription.trailingLayoutItems
    }
    
    // Positionable
    var position = Point.zero
    
    var beams = [Beam]()
    
    // MARK: - Init
    public init(value: NoteValue, pitch: Pitch) {
        self.value = value
        self.pitch = pitch
    }
}

public enum Accidental {
    case none
    case sharp
}

enum Beam {
    case connectedNext
    case connectedPrevious
    case connectedBoth
    case cutOffLeft
    case cutOffRight
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
    let numberOfTails: Int
    var leadingLayoutItems = [AdjacentLayoutItem]()
    var trailingLayoutItems = [AdjacentLayoutItem]()
    
    init(headStyle: HeadStyle, hasStem: Bool, numberOfTails: Int) {
        self.headStyle = headStyle
        self.hasStem = hasStem
        self.numberOfTails = numberOfTails
    }
    
    static var standard: NoteSymbolDescription {
        return NoteSymbolDescription(headStyle: .none, hasStem: false, numberOfTails: 0)
    }
}
