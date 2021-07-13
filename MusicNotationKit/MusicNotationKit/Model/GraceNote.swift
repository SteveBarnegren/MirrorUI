//
//  GraceNote.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 03/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

public class GraceNote: AdjacentLayoutItem, Positionable {

    var pitch: Pitch
    var stavePosition = StavePosition.zero
    var stemDirection = StemDirection.up
    var stemLength: Double = 0

    var floatingArticulationMarks = [FloatingArticulationMark]()

    /// The stem connection point, relative to the grace note position
    var stemConnectionPoint = Vector2D.zero

    var beams = [Beam]()

    var stemEndY: Double {
        position.y + stemLength.inverted(if: stemDirection == .down)
    }

    //AdjacentLayoutItem
    var hoizontalLayoutDistanceFromParentItem: Double = 0
    var horizontalLayoutWidth = HorizontalLayoutWidthType.centered(width: 1)
    var position: Vector2D = .zero

    public init(pitch: Pitch) {
        self.pitch = pitch
    }
}

extension GraceNote {

    func stemLeadingEdge(metrics: FontMetrics) -> Double {
        switch stemDirection {
            case .up:
                return xPosition + stemConnectionPoint.x - metrics.graceNoteStemThickness
            case .down:
                return xPosition + stemConnectionPoint.x
        }
    }

    func stemTrailingEdge(metrics: FontMetrics) -> Double {
        switch stemDirection {
            case .up:
                return xPosition + stemConnectionPoint.x
            case .down:
                return xPosition + stemConnectionPoint.x + metrics.graceNoteStemThickness
        }
    }
}

// MARK: - Creation conviniences

extension GraceNote {
    public func textArticulation(_ text: String) -> GraceNote {
        let textArticulation = TextArticulation(text: text)
        floatingArticulationMarks.append(textArticulation)
        return self
    }
}

extension GraceNote {

    func calculateMaxY() -> Double {
        return max(stemEndY, yPosition)
    }
}
