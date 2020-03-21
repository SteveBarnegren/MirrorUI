//
//  Note.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

public enum NoteHeadType {
    case standard
    case cross
}

public class Note: Playable {
    
    public var accidental = Accidental.none
    public var noteHeadType = NoteHeadType.standard
    
    let pitches: [Pitch]
    var highestPitch: Pitch { return pitches.max()! }
    var lowestPitch: Pitch { return pitches.min()! }
    
    var symbolDescription = NoteSymbolDescription.standard
    var noteHeadDescriptions = [NoteHeadDescription]()
    
    // Width
    var layoutDuration: Time? {
        return self.duration
    }
    
    // Playable
    let value: NoteValue
    var time = Time.zero
    
    // HorizontalLayoutItem
    let horizontalLayoutWidth: Double = 1.4

    var leadingLayoutItems: [AdjacentLayoutItem] {
        return self.noteHeadDescriptions.map { $0.leadingLayoutItems }.joined().toArray()
        //return self.symbolDescription.leadingLayoutItems
    }
    var trailingLayoutItems: [AdjacentLayoutItem] {
        return self.noteHeadDescriptions.map { $0.trailingLayoutItems }.joined().toArray()
        //return self.symbolDescription.trailingLayoutItems
    }
    
    // HorizontallyPositionable
    var xPosition = Double(0)
    var yPosition = Double(0)
    
    var beams = [Beam]()
    
    // MARK: - Init
    public init(value: NoteValue, pitch: Pitch) {
        self.value = value
        self.pitches = [pitch]
    }
    
    public init(value: NoteValue, pitches: [Pitch]) {
           self.value = value
           self.pitches = pitches
       }
    
    // Acidentals
    public func sharp() -> Note {
        self.accidental = .sharp
        return self
    }
    
    public func flat() -> Note {
        self.accidental = .flat
        return self
    }
    
    public func natural() -> Note {
        self.accidental = .natural
        return self
    }
    
    // Note Head
    public func crossHead() -> Note {
        self.noteHeadType = .cross
        return self
    }
}

public enum Accidental {
    case none
    case sharp
    case flat
    case natural
}

enum Beam {
    case connectedNext
    case connectedPrevious
    case connectedBoth
    case cutOffLeft
    case cutOffRight
}

enum StemDirection {
    case up
    case down
}

class NoteHeadDescription {
    
    enum Style {
        case none
        case semibreve
        case open
        case filled
        case cross
    }
    
    let style: Style
    var leadingLayoutItems = [AdjacentLayoutItem]()
    var trailingLayoutItems = [AdjacentLayoutItem]()
    
    init(style: Style) {
        self.style = style
    }
}

class NoteSymbolDescription {
    
    let hasStem: Bool
    let numberOfTails: Int
    var stemDirection = StemDirection.up
    var stemLength = Double(0)
    
    var stemEndOffset: Double {
        return stemLength.inverted(if: { stemDirection == .down })
    }
    
    init(hasStem: Bool, numberOfTails: Int) {
        self.hasStem = hasStem
        self.numberOfTails = numberOfTails
    }
    
    static var standard: NoteSymbolDescription {
        return NoteSymbolDescription(hasStem: false, numberOfTails: 0)
    }
}

/*
class NoteSymbolDescription {
    
    enum HeadStyle {
        case none
        case semibreve
        case open
        case filled
        case cross
    }
    
    let headStyle: HeadStyle
    let hasStem: Bool
    let numberOfTails: Int
    var leadingLayoutItems = [AdjacentLayoutItem]()
    var trailingLayoutItems = [AdjacentLayoutItem]()
    var stemDirection = StemDirection.up
    var stemLength = Double(0)
    
    var stemEndOffset: Double {
        return stemLength.inverted(if: { stemDirection == .down })
    }
    
    init(headStyle: HeadStyle, hasStem: Bool, numberOfTails: Int) {
        self.headStyle = headStyle
        self.hasStem = hasStem
        self.numberOfTails = numberOfTails
    }
    
    static var standard: NoteSymbolDescription {
        return NoteSymbolDescription(headStyle: .none, hasStem: false, numberOfTails: 0)
    }
}
*/
