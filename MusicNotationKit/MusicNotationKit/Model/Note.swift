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
    
    public var noteHeadType = NoteHeadType.standard
    
    /// Pitches, in ascending order
    let pitches: [Pitch]
    var highestPitch: Pitch { return pitches.max()! }
    var lowestPitch: Pitch { return pitches.min()! }
    
    var noteHeadDescriptions = [NoteHeadDescription]()
    var articulationMarks = [ArticulationMark]()
    
    var tiedToNext = false
    
    var numberOfTails: Int = 0
    
    // MARK: - Stem
    
    /// If the note has a stem
    var hasStem: Bool = false
    
    var stemDirection = StemDirection.up
    
    var stemLength = Double(0)
    
    var stemEndOffset: Double {
        return stemLength.inverted(if: { stemDirection == .down })
    }
    
    /// The note head that the stem connects to
    var stemConnectingNoteHead: NoteHeadDescription {
        // We always expect there to be at least one note note head
        switch stemDirection {
        case .up:
            return noteHeadDescriptions.min(byKey: \.staveOffset)!
        case .down:
            return noteHeadDescriptions.max(byKey: \.staveOffset)!
        }
    }
    
    var stemExtendingNoteHead: NoteHeadDescription {
        // We always expect there to be at least one note note head
        switch stemDirection {
        case .up:
            return noteHeadDescriptions.max(byKey: \.staveOffset)!
        case .down:
            return noteHeadDescriptions.min(byKey: \.staveOffset)!
        }
    }
    
    /// The stem connection point, relative to the note position
    var stemConnectionPoint = Vector2D.zero
    
    /// The width of the stem, as specified by the font being used to render the note
    var stemWidth = Double.zero
    
    /// The absolute x position of the stem's center
    var stemCenterX: Double {
        switch stemDirection {
        case .up:
            return xPosition + stemConnectionPoint.x - stemWidth/2
        case .down:
            return xPosition + stemConnectionPoint.x + stemWidth/2
        }
    }
    
    /// The absolute position of the stem's leading edge
    var stemLeadingEdge: Double {
        return stemCenterX - stemWidth/2
    }
    
    /// The absolute position of the stem's trailing edge
    var stemTrailingEdge: Double {
        return stemCenterX + stemWidth/2
    }
    
    /// The y position of the end of the note stem
    var stemEndY: Double {
        switch stemDirection {
        case .up:
            return stemConnectingNoteHead.yPosition + stemLength
        case .down:
            return stemConnectingNoteHead.yPosition - stemLength
        }
    }
    
    // Width
    var layoutDuration: Time? {
        return self.duration
    }
    
    // Playable
    var value: NoteValue
    var barTime = Time.zero
    var compositionTime = CompositionTime.zero
    
    // HorizontalLayoutItem
    var horizontalLayoutWidth = HorizontalLayoutWidthType.centered(width: 1.4)

    var leadingLayoutItems: [AdjacentLayoutItem] {
        return self.noteHeadDescriptions.map { $0.leadingLayoutItems }.joined().toArray()
    }
    var trailingLayoutItems: [AdjacentLayoutItem] {
        return self.noteHeadDescriptions.map { $0.trailingLayoutItems }.joined().toArray()
    }
    
    // HorizontallyPositionable
    var xPosition = Double(0) {
        didSet {
            assert(!xPosition.isNaN)
            assert(!xPosition.isInfinite)
        }
    }
    
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
    @discardableResult public func tied() -> Note {
        self.tiedToNext = true
        return self
    }
    
    // Note Head
    @discardableResult public func crossHead() -> Note {
        self.noteHeadType = .cross
        return self
    }
    
    // Accent
    @discardableResult public func accent() -> Note {
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
    
    var isUp: Bool { self == .up }
    var isDown: Bool { self == .down }
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
