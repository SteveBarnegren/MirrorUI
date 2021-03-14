//
//  TieRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

private let roundedEndRadius = 0.06
private let middleThickness = 0.25

private enum CircleConnection {
    case over
    case under
}

private struct CubicBezier {
    var start: Vector2D
    var end: Vector2D
    var cp1: Vector2D
    var cp2: Vector2D
    
    func reversed() -> CubicBezier {
        return CubicBezier(start: end,
                           end: start,
                           cp1: cp2,
                           cp2: cp1)
    }
}

class TieRenderer {
    
    private let glyphs: GlyphStore
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func paths(forTie tie: Tie,
               inBarRange barRange: ClosedRange<Int>,
               canvasWidth: Double) -> [Path] {
        
        guard let fromNote = tie.fromNote else {
            print("Error - tie had no from note")
            return []
        }
        
        guard let fromNoteHead = tie.fromNoteHead else {
            print("Error - tie had no from note head")
            return []
        }
        
        guard let endNote = tie.toNote else {
            print("Error - tie had no end note")
            return []
        }
        
        guard let endNoteHead = tie.toNoteHead else {
            print("Error - tie had no end note head")
            return []
        }
        
        let arcY = yPosition(fromTiePosition: tie.middlePosition)
            + yOffset(forMiddleAlignment: tie.middleAlignment)
        let orientationOffset = Vector2D(xOffset(forOrientation: tie.orientation),
                                      yOffset(forEndAlignment: tie.endAlignment))
      
        let startY = yPosition(fromTiePosition: tie.startPosition) + orientationOffset.y
        let startX: Double
        let endX: Double
        
        if barRange.contains(tie.startNoteCompositionTime.bar) && barRange.contains(tie.endNoteCompositionTime.bar) {
            
            startX = xPosition(forNote: fromNote, noteHead: fromNoteHead) + orientationOffset.x
            endX = xPosition(forNote: endNote, noteHead: endNoteHead) - orientationOffset.x
            
        } else if barRange.contains(tie.startNoteCompositionTime.bar) {

            startX = xPosition(forNote: fromNote, noteHead: fromNoteHead) + orientationOffset.x
            endX = canvasWidth
            
        } else {
            startX = 0
            endX = xPosition(forNote: endNote, noteHead: endNoteHead) - orientationOffset.x
        }
        
        var path = pathForFullTie(startX: startX, endX: endX, startY: startY, arcY: arcY)
        path.drawStyle = .fill
        
        return [path]
    }
    
    // MARK: - Full Tie
    
    private func pathForFullTie(startX: Double, endX: Double, startY: Double, arcY: Double) -> Path {
        
        let tieIsNegative = startY > arcY
        let tieStartY = min(startY, arcY)
        let tieArcY = max(startY, arcY)
        let tieWidth = endX - startX
        
        let rect = Rect(x: startX,
                        y: tieStartY,
                        width: tieWidth,
                        height: tieArcY - tieStartY)
        
        // Get the centers of the end circles
        let leftCircleCenter = Vector2D(rect.minX + roundedEndRadius, tieStartY + roundedEndRadius)
        let rightCircleCenter = Vector2D(rect.maxX - roundedEndRadius, tieStartY + roundedEndRadius)
        
        // Draw the top bezier
        let topRect = rect.adding(height: middleThickness/2)
        let topResults = commands(forBezierInRect: topRect,
                                  circleConnection: .over)
        let topPathCommands = topResults.commands
        let topPathStart = topResults.start
        let topPathEnd = topResults.end
        
        // Draw the bottom bezier
        let bottomResults = commands(forBezierInRect: rect.subtracting(height: middleThickness/2),
                                     circleConnection: .under,
                                     reverse: true)
        let bottomPathCommands = bottomResults.commands
        let bottomPathStart = bottomResults.start
        let bottomPathEnd = bottomResults.end
        
        var fullPathCommands = [Path.Command.move(topPathStart.asPoint())]
        // var fullPathCommands = [Path.Command]()

        fullPathCommands += topPathCommands
        
        // Add the left right side rounded end
        fullPathCommands.append(
            .arc(center: rightCircleCenter.asPoint(),
                 radius: roundedEndRadius,
                 startAngle: circleAngle(center: rightCircleCenter, point: topPathEnd),
                 endAngle: circleAngle(center: rightCircleCenter, point: bottomPathStart),
                 clockwise: true)
        )
        
        fullPathCommands.append(contentsOf: bottomPathCommands)
        
        // Add the left side rounded end
        fullPathCommands.append(
            .arc(center: leftCircleCenter.asPoint(),
                 radius: roundedEndRadius,
                 startAngle: circleAngle(center: leftCircleCenter, point: bottomPathEnd),
                 endAngle: circleAngle(center: leftCircleCenter, point: topPathStart),
                 clockwise: true)
        )
        
        // Flip if the tie is negative (the middle dips downwards not upwards)
        if tieIsNegative {
            fullPathCommands = flipPathCommandsY(commands: fullPathCommands,
                                                 minY: tieStartY,
                                                 maxY: tieArcY)
        }
        
        var path = Path(commands: fullPathCommands)
        path.drawStyle = .fill
        return path
    }
    
    private func commands(forBezierInRect rect: Rect,
                          circleConnection: CircleConnection,
                          reverse: Bool = false) -> (commands: [Path.Command], start: Vector2D, end: Vector2D) {
        
        let arcTop = Vector2D(rect.midX, rect.maxY)
        
        let minArcY: Double
        let maxArcY: Double
        switch circleConnection {
        case .over:
            minArcY = rect.minY + (roundedEndRadius*2)
            maxArcY = rect.minY + (rect.width/2 + roundedEndRadius)
        case .under:
            minArcY = rect.minY
            maxArcY = rect.minY + (rect.width - roundedEndRadius*4)/2 + roundedEndRadius
        }
        
        let arcAmount = arcTop.y.inverseLerp(between: minArcY, and: maxArcY)
        
        let minConnectionAngle = Double(0)
        let maxConnectionAngle = Double.pi/2
        let angle = minConnectionAngle
            .lerp(to: maxConnectionAngle, t: arcAmount)
            .constrained(min: minConnectionAngle, max: maxConnectionAngle)
        
        let overUnderMultiplier = (circleConnection == .over ? 1.0 : -1.0)
        let circleConnection = Vector2D(rect.minX + roundedEndRadius, rect.minY + roundedEndRadius)
            .subtracting(x: sin(angle) * roundedEndRadius * overUnderMultiplier)
            .adding(y: cos(angle) * roundedEndRadius * overUnderMultiplier)
        
        let circleConnectionXInset = circleConnection.x - rect.minX
        let circleConnectionYInset = circleConnection.y - rect.minY
        let bezierRect = Rect(origin: circleConnection,
                              size: Vector2D(rect.width - circleConnectionXInset*2, rect.height - circleConnectionYInset))
        var bezier = createBezier(inRect: bezierRect)
        var start = Vector2D(bezierRect.minX, bezierRect.minY)
        var end = Vector2D(bezierRect.maxX, bezierRect.minY)
        if reverse {
            bezier = bezier.reversed()
            swap(&start, &end)
        }
        
        let commands = self.commands(fromBezier: bezier)
        return (commands, start, end)
    }
    
    private func circleAngle(center: Vector2D, point: Vector2D) -> Double {
        let yDiff = point.y - center.y
        let xDiff = point.x - center.x
        var angle = atan(yDiff/xDiff)
        
        if point.x < center.x {
            angle += .pi
        }
        
        return angle
    }
    
    private func commands(fromBezier bezier: CubicBezier) -> [Path.Command] {
        let curve = Path.Command.curve(bezier.end.asPoint(), c1: bezier.cp1.asPoint(), c2: bezier.cp2.asPoint())
        return [.line(Vector2D(bezier.start.x, bezier.start.y)), curve]
    }
    
    private func flipPathCommandsY(commands: [Path.Command], minY: Double, maxY: Double) -> [Path.Command] {
        
        var newCommands = [Path.Command]()
        
        func flip(_ p: Vector2D) -> Vector2D {
            return Vector2D(p.x,
                         maxY - (p.y - minY))
        }
        
        for command in commands {
            switch command {
            case .move(let p):
                newCommands.append(.move(flip(p)))
            case .line(let p):
                newCommands.append(.line(flip(p)))
            case .curve(let p, let c1, let c2):
                newCommands.append(.curve(flip(p), c1: flip(c1), c2: flip(c2)))
            case .quadCurve(let p, let c1):
                newCommands.append(.quadCurve(flip(p), c1: flip(c1)))
            case .close:
                newCommands.append(.close)
            case .circle(let center, let radius):
                newCommands.append(.circle(flip(center), radius))
            case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                newCommands.append(
                    .arc(center: flip(center),
                         radius: radius,
                         startAngle: .pi - startAngle,
                         endAngle: .pi - endAngle,
                         clockwise: !clockwise)
                )
            }
        }
        
        return newCommands
    }
    
    // MARK: - Create Arc Beziers
    
    private func createBezier(inRect rect: Rect) -> CubicBezier {
        
        // If there's not space to create the arc, the control points should be vertical.
        // (The arc slope calculation will extend the curve outside the rect to hit the
        // top)
        let slope: Double
        if doesRectFitArc(rect) {
            slope = arcSlopeForBezier(inRect: rect)
        } else {
            slope = Double.greatestFiniteMagnitude
        }
        
        return createBezier(inRect: rect, slope: slope)
    }
    
    // Slope must be from a normalised vector
    private func createBezier(inRect rect: Rect, slope: Double) -> CubicBezier {
        
        // Work out the offset of the control points based on the slope
        var offset = Vector2D(rect.height * 1/slope,
                              rect.height)
        
        // Adjust so that the peak of the curve will hit the target y (This only works because it's symmetrical)
        offset *= 1/0.75
        
        // Create the bezier
        let start = rect.origin
        let end = Vector2D(rect.maxX, rect.minY)
        let c1 = start + offset
        let c2 = end + offset.flipX()
        
        return CubicBezier(start: start,
                           end: end,
                           cp1: c1,
                           cp2: c2)
    }
    
    private func doesRectFitArc(_ rect: Rect) -> Bool {
        // To fit an chord of the circle in the rect so that the chord hits the top of the
        // rect, there needs to be enough width for height that the height can be fitted
        // twice in the width
        return abs(rect.height) <= abs(rect.width/2)
    }
    
    private func arcSlopeForBezier(inRect rect: Rect) -> Double {
        
        // Find the chord from the start to the top of the arc
        let arcStart = rect.origin
        let arcTop  = Vector2D(rect.midX, rect.maxY)
        let chordMid = arcStart.lerp(to: arcTop, t: 0.5)
        
        // The slope to the center is perpendicular to the chord slope
        let chordSlope = arcStart.slope(to: arcTop)
        let chordToCenterSlope = -1 / chordSlope
        
        // Find the center of the circle. x is the same as the top of the arc, so just solve for y
        let centerX = arcTop.x
        let centerY = chordMid.y + (arcTop.x-chordMid.x)*chordToCenterSlope
        let center = Vector2D(centerX, centerY)
        
        // Figure out the slope back to the arc start
        let startToCenter = center - arcStart
        let slopeToStart = startToCenter.slope
        
        // The starting slope is perpendicular to the start to center slope
        let startSlope = -1 / slopeToStart
        return startSlope
    }
    
    // MARK: - Leading Tie
    
    func paths(forLeadingTie tie: Tie) -> [Path] {
        
        guard let endNote = tie.toNote else {
            print("Error - Tie end note not set")
            return []
        }
        
        guard let endNoteHead = tie.toNoteHead else {
            print("Error - Tie end note head not set")
            return []
        }
        
        let midX = 0.0
        let midY = yPosition(fromTiePosition: tie.middlePosition) + yOffset(forMiddleAlignment: tie.middleAlignment)
        
        let endX = xPosition(forNote: endNote, noteHead: endNoteHead) - xOffset(forOrientation: tie.orientation)
        let endY = yPosition(fromTiePosition: tie.startPosition) + yOffset(forEndAlignment: tie.endAlignment)
        
        var path = Path(commands: [
            .move(Vector2D(midX, midY)),
            .line(Vector2D(endX, endY))
        ])
        
        path.drawStyle = .stroke
        return [path]
    }
    
    private func xPosition(forNote note: Note, noteHead: NoteHead) -> Double {
        return note.xPosition
            + NoteHeadAligner.xOffset(forNoteHead: noteHead, glyphs: glyphs)
    }
    
    private func yPosition(fromTiePosition tiePosition: TiePosition) -> Double {
        let stavePosition = tiePosition.space.stavePosition
        let staveOffset = StavePositionUtils.staveYOffset(forStavePostion: stavePosition)
        return staveOffset
    }
    
    private func yOffset(forEndAlignment alignment: TieEndAlignment) -> Double {
        switch alignment {
        case .middleOfSpace:
            return 0
        case .sittingAboveNoteHead:
            return 0.25
        case .hangingBelowNoteHead:
            return -0.25
        case .top:
            return 0.25
        case .bottom:
            return -0.25
        }
    }
    
    private func yOffset(forMiddleAlignment alignment: TieMiddleAlignment) -> Double {
        switch alignment {
        case .middleOfSpace:
            return 0
        case .topOfSpace:
            return 0.25
        case .bottomOfSpace:
            return -0.25
        }
    }
    
    private func xOffset(forOrientation orientation: TieOrientation) -> Double {
        switch orientation {
        case .verticallyAlignedWithNote:
            return 0
        case .adjacentToNote:
            return 1
        }
    }
}

extension Int {
    
    var isPositive: Bool {
        return self >= 0
    }
    
    var isNegative: Bool {
        return !self.isPositive
    }
}

extension Vector2D {
    func asPoint() -> Vector2D {
        return Vector2D(self.x, self.y)
    }
}
