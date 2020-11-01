//
//  ConflictIdentifer+Ties.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 14/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

//swiftlint:disable for_where

import Foundation

class ConflictIdentifiers {}

extension ConflictIdentifiers {
    static var ties: ConflictIdentifier<Tie, Tie> {
        return ConflictIdentifier<Tie, Tie>.init(areCompatible: areTiesCompatable)
    }
    
    static private func areTiesCompatable(tie1: Tie, tie2: Tie) -> Bool {
        
        func does(_ p1: Vector2D, _ p2: Vector2D, intersectWith p3: Vector2D, _ p4: Vector2D) -> Bool {
            return VectorMath.lineSegmentsIntersect(start1: p1, end1: p2, start2: p3, end2: p4)
        }
        
        let t1 = makeVectors(forTie: tie1)
        let t2 = makeVectors(forTie: tie2)
        
        for v1 in [t1.start, t1.middle, t1.end] {
            for v2 in [t2.start, t2.middle, t2.end] {
                if v1 == v2 {
                    return false
                }
            }
        }
        
        if does(t1.start, t1.middle, intersectWith: t2.start, t2.middle) {
            return false
        }
        if does(t1.start, t1.middle, intersectWith: t2.middle, t2.end) {
            return false
        }
        if does(t1.middle, t1.end, intersectWith: t2.start, t2.middle) {
            return false
        }
        if does(t1.middle, t1.end, intersectWith: t2.middle, t2.end) {
            return false
        }
        
        return true
    }
    
    private static func makeVectors(forTie tie: Tie) -> (start: Vector2D, middle: Vector2D, end: Vector2D) {

        // xNudge is used to nudge adjacent vectors so that they don't share the same start
        // point as vertically aligned ones. This ensures that they're not incorrectly
        // identified as sharing a point.
        let xNudge: Double
        switch tie.orientation {
        case .verticallyAlignedWithNote:
            xNudge = 0
        case .adjacentToNote:
            xNudge = 0.001
        }
        
        return (
            makeVector(tie.startNoteCompositionTime.absoluteTime, tie.startPosition).adding(x: xNudge),
            makeVector(tie.startNoteCompositionTime.absoluteTime + ((tie.endNoteCompositionTime.absoluteTime - tie.startNoteCompositionTime.absoluteTime)/2), tie.middlePosition),
            makeVector(tie.endNoteCompositionTime.absoluteTime, tie.startPosition).subtracting(x: xNudge)
        )
    }
    
    private static func makeVector(_ x: Time, _ y: TiePosition) -> Vector2D {
        return Vector2D(Double(x.value) / Double(x.division),
                        Double(y.space.stavePosition))
    }
}
