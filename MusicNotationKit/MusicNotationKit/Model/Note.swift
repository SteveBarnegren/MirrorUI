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
    
    //public var accidental = Accidental.none
    public var noteHeadType = NoteHeadType.standard
    
    /// Pitches, in ascending order
    let pitches: [Pitch]
    var highestPitch: Pitch { return pitches.max()! }
    var lowestPitch: Pitch { return pitches.min()! }
    
    var symbolDescription = NoteSymbolDescription.standard
    var noteHeadDescriptions = [NoteHeadDescription]()
    var articulationMarks = [ArticulationMark]()
    
    var tiedToNext = false
    
    /// The note head that the stem connects to
    var stemConnectingNoteHead: NoteHeadDescription {
        // We always expect there to be at least one note note head
        switch symbolDescription.stemDirection {
        case .up:
            return noteHeadDescriptions.min(byKey: \.staveOffset)!
        case .down:
            return noteHeadDescriptions.max(byKey: \.staveOffset)!
        }
    }
    
    var stemExtendingNoteHead: NoteHeadDescription {
        // We always expect there to be at least one note note head
        switch symbolDescription.stemDirection {
        case .up:
            return noteHeadDescriptions.max(byKey: \.staveOffset)!
        case .down:
            return noteHeadDescriptions.min(byKey: \.staveOffset)!
        }
    }
    
    // Width
    var layoutDuration: Time? {
        return self.duration
    }
    
    // Playable
    var value: NoteValue
    var time = Time.zero
    var compositionTime = CompositionTime.zero
    
    // HorizontalLayoutItem
    var horizontalLayoutWidth = HorizontalLayoutWidthType.centered(width: 1.4)

    var leadingLayoutItems: [AdjacentLayoutItem] {
        return self.noteHeadDescriptions.map { $0.leadingLayoutItems }.joined().toArray()
        //return self.symbolDescription.leadingLayoutItems
    }
    var trailingLayoutItems: [AdjacentLayoutItem] {
        return self.noteHeadDescriptions.map { $0.trailingLayoutItems }.joined().toArray()
        //return self.symbolDescription.trailingLayoutItems
    }
    
    // HorizontallyPositionable
    var xPosition = Double(0) {
        didSet {
            assert(!xPosition.isNaN)
            assert(!xPosition.isInfinite)
        }
    }
    //var yPosition = Double(0)
    
    var beams = [Beam]()
    
    // MARK: - Init
    public init(value: NoteValue, pitch: Pitch) {
        self.value = value
        self.pitches = [pitch]
    }
    
    public init(value: NoteValue, pitches: [Pitch]) {
           self.value = value
        self.pitches = pitches.sorted()
       }
    
    // Tie
    public func tied() -> Note {
        self.tiedToNext = true
        return self
    }
    
    // Note Head
    public func crossHead() -> Note {
        self.noteHeadType = .cross
        return self
    }
    
    // Accent
    public func accent() -> Note {
        self.articulationMarks.append(Accent())
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

enum NoteHeadAlignment {
    case center
    case leftOfStem
    case rightOfStem
}

class NoteHeadDescription: VerticallyPositionable {
    
    enum Style {
        case none
        case semibreve
        case open
        case filled
        case cross
    }
    
    let style: Style
    var alignment = NoteHeadAlignment.center
    var stavePosition = Int(0)
    var staveOffset = Double(0)
    var leadingLayoutItems = [AdjacentLayoutItem]()
    var trailingLayoutItems = [AdjacentLayoutItem]()
    var tie: VariationSet<Tie>?
    
    // VerticallyPositionable
    var yPosition: Double = 0

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
