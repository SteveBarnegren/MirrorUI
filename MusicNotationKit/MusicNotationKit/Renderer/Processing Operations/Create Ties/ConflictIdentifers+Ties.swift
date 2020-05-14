//
//  ConflictIdentifer+Ties.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 14/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class ConflictIdentifiers {}

extension ConflictIdentifiers {
    static var ties: ConflictIdentifier<Tie, Tie> {
        return ConflictIdentifier<Tie, Tie>.init(areCompatible: areTiesCompatable)
    }
    
    static private func areTiesCompatable(tie1: Tie, tie2: Tie) -> Bool {
        
        func makeVector(_ x: Time, _ y: TiePosition) -> Vector2D {
            return Vector2D(x.barPct,
                            Double(y.space.stavePosition))
        }
        
        func makeVectors(forTie tie: Tie) -> (start: Vector2D, middle: Vector2D, end: Vector2D) {
            return (
                makeVector(tie.startNoteTime.time, tie.startPosition),
                makeVector(tie.startNoteTime.time + ((tie.endNoteTime.time - tie.startNoteTime.time)/2), tie.middlePosition),
                makeVector(tie.endNoteTime.time, tie.startPosition)
            )
        }
        
        func does(_ p1: Vector2D, _ p2: Vector2D, intersectWith p3: Vector2D, _ p4: Vector2D) -> Bool {
            return VectorMath.lineSegmentsIntersect(start1: p1, end1: p2, start2: p3, end2: p4)
        }
        
        // If the ties aren't in the same bar then we'll assume that they're not in
        // conflict. This isn't actually true, but it handles the most common cases.
        if tie1.startNoteTime.bar != tie2.startNoteTime.bar || tie1.endNoteTime.bar != tie2.endNoteTime.bar {
            return true
        }
        
        
        let t1 = makeVectors(forTie: tie1)
        let t2 = makeVectors(forTie: tie2)
        //print("t1 s: (\(t1.start.x), \(t1.start.y))")
        //print("t1 m: (\(t1.middle.x), \(t1.middle.y))")
       // print("t1 e: (\(t1.end.x), \(t1.end.y))")
        
        //print("t2 s: (\(t2.start.x), \(t2.start.y))")
        //print("t2 m: (\(t2.middle.x), \(t2.middle.y))")
       // print("t2 e: (\(t2.end.x), \(t2.end.y))")
        
        for v1 in [t1.start, t1.middle, t1.end] {
            for v2 in [t2.start, t2.middle, t2.end] {
                if v1 == v2 {
                    //print("Ties contain same point")
                    return false
                }
            }
        }
        
        if does(t1.start, t1.middle, intersectWith: t2.start, t2.middle) {
            //print("First halves intersect")
            return false
        }
        if does(t1.start, t1.middle, intersectWith: t2.middle, t2.end) {
           // print("t1 first half intersect t2 second half")
            return false
        }
        if does(t1.middle, t1.end, intersectWith: t2.start, t2.middle) {
            //print("t1 second half intersect t2 first half")
            return false
        }
        if does(t1.middle, t1.end, intersectWith: t2.middle, t2.end) {
           // print("Second halves intersect")
            return false
        }
        
        //print("Compatible")
        return true
    }
}
