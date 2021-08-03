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
    var unpitched = false

    var noteHeads = [NoteHead]()
    var articulationMarks = [ArticulationMark]()
    var floatingArticulationMarks = [FloatingArticulationMark]()

    var noteHeadStavePositions: [StavePosition] {
        if unpitched {
            return [StavePosition.zero]
        } else {
            return noteHeads.map { $0.stavePosition }
        }
    }
    
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
    var stemConnectingNoteHead: NoteHead {
        // We always expect there to be at least one note note head
        switch stemDirection {
        case .up:
            return noteHeads.min(byKey: \.stavePosition)!
        case .down:
            return noteHeads.max(byKey: \.stavePosition)!
        }
    }
    
    var stemExtendingNoteHead: NoteHead {
        // We always expect there to be at least one note note head
        switch stemDirection {
        case .up:
            return noteHeads.max(byKey: \.stavePosition)!
        case .down:
            return noteHeads.min(byKey: \.stavePosition)!
        }
    }
    
    /// The stem connection point, relative to the note position
    var stemConnectionPoint = Vector2D.zero
    
    /// The y position of the end of the note stem
    var stemEndY: Double {
        switch stemDirection {
        case .up:
            return stemConnectingNoteHead.yPosition + stemLength
        case .down:
            return stemConnectingNoteHead.yPosition - stemLength
        }
    }

    var stemAugmentation: StemAugmentation?
    var stemAugmentationAttachmentPoint: Vector2D {
        Vector2D(xPosition + stemConnectionPoint.x, (stemConnectionPoint.y + stemEndY) / 2)
    }
    
    // Grace notes
    var graceNotes = [GraceNote]()
    
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

    var leadingChildItems: [AdjacentLayoutItem] {
        var items = [AdjacentLayoutItem]()
        items += graceNotes
        items += self.noteHeads.map { $0.leadingLayoutItems }.joined().toArray()
        return items
    }
    var trailingChildItems: [AdjacentLayoutItem] {
        return self.noteHeads.map { $0.trailingLayoutItems }.joined().toArray()
    }
    
    // HorizontallyPositionable
    var xPosition = Double(0) {
        didSet {
            assert(!xPosition.isNaN)
            assert(!xPosition.isInfinite)
        }
    }
    
    // Beams
    
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

    public init(unpitched value: NoteValue) {
        self.value = value
        self.unpitched = true
        self.pitches = []
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

    // Text Articulation
    @discardableResult public func textArticulation(_ text: String) -> Note {
        self.articulationMarks.append(TextArticulation(text: text))
        return self
    }

    // Floating Text Articulation
    @discardableResult public func floatingTextArticulation(_ text: String) -> Note {
        self.floatingArticulationMarks.append(FloatingTextArticulation(text: text))
        return self
    }

    // Grace note
    @discardableResult public func addGraceNotes(_ graceNotes: [GraceNote]) -> Note {
        // We store grace notes in reversed order
        self.graceNotes += graceNotes.reversed()
        return self
    }

    // Stem Augmentation
    @discardableResult public func stemAugmentation(_ augmentation: StemAugmentation) -> Note {
        self.stemAugmentation = augmentation
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

class NoteHead: VerticallyPositionable {
    
    enum Style {
        case none
        case semibreve
        case open
        case filled
        case cross
    }
    
    let style: Style
    var alignment = NoteHeadAlignment.center
    var stavePosition = StavePosition.zero
    var leadingLayoutItems = [AdjacentLayoutItem]()
    var trailingLayoutItems = [AdjacentLayoutItem]()
    var tie: VariationSet<Tie>?
    
    // VerticallyPositionable
    var yPosition: Double = 0

    init(style: Style) {
        self.style = style
    }
}

// MARK: - Stem position

extension Note {

    /// The absolute x position of the stem's center
    func stemCenterX(metrics: FontMetrics) -> Double {
        switch stemDirection {
        case .up:
            return xPosition + stemConnectionPoint.x - metrics.stemThickness/2
        case .down:
            return xPosition + stemConnectionPoint.x + metrics.stemThickness/2
        }
    }

    /// The absolute position of the stem's leading edge
    func stemLeadingEdge(metrics: FontMetrics) -> Double {
        switch stemDirection {
            case .up:
                return xPosition + stemConnectionPoint.x - metrics.stemThickness
            case .down:
                return xPosition + stemConnectionPoint.x
        }
    }

    /// The absolute position of the stem's trailing edge
    func stemTrailingEdge(metrics: FontMetrics) -> Double {
        switch stemDirection {
            case .up:
                return xPosition + stemConnectionPoint.x
            case .down:
                return xPosition + stemConnectionPoint.x + metrics.stemThickness
        }
    }
}

extension Note {

    func calculateMaxY() -> Double {
        let noteHeadsMax = noteHeads.map { $0.yPosition }.max() ?? 0
        return max(stemEndY, noteHeadsMax)
    }
}
