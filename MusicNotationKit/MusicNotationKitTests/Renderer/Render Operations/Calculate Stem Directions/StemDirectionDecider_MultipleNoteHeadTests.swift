//
//  StemDirectionDecider_MultipleNoteHeadTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 21/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

private class TestNote {
    var stavePositions: [Int]
    var stemDirection = StemDirection.up
    
    init(stavePositions: [Int]) {
        self.stavePositions = stavePositions
    }
}

class StemDirectionDecider_MultipleNoteHeadTests: XCTestCase {
    
    private var decider: StemDirectionDecider<TestNote>!
    
    override func setUp() {
        super.setUp()
        let tf = StemDirectionDecider<TestNote>.Transformer<TestNote>(stavePositions: { $0.stavePositions },
                                                                      setStemDirection: { $0.stemDirection = $1 })
        decider = StemDirectionDecider(transformer: tf)
    }
    
    // MARK: - Intervals (Two note heads)
    
    // The notehead the furthest awat from the center of the stave determines the stem
    // direction. When this note is above the middle line, the chord takes a down-stem;
    // when the note is below the middle line, the chord takes an up-stem.
    
    func test_Intervals() {
        
        // Single note
        assert(stavePositions: [[1, -2]], direction: .up)
        assert(stavePositions: [[-1, 2]], direction: .down)
        assert(stavePositions: [[1, -3]], direction: .up)
        assert(stavePositions: [[3, -2]], direction: .down)
        assert(stavePositions: [[3, -4]], direction: .up)
        assert(stavePositions: [[4, -3]], direction: .down)
        assert(stavePositions: [[-5, 4]], direction: .up)
        assert(stavePositions: [[8, -10]], direction: .up)
        
        // Two notes
        assert(stavePositions: [[-1, -3], [2, 4]], direction: .down)
        assert(stavePositions: [[-2, -6], [3, 5]], direction: .up)
    }
    
    func test_Intervals_EquidistantFromCentre_ShouldHaveDownwardsStems() {
        
        // Single note
        assert(stavePositions: [[1, -1]], direction: .down)
        assert(stavePositions: [[-1, 1]], direction: .down)
        assert(stavePositions: [[2, -2]], direction: .down)
        assert(stavePositions: [[-2, 2]], direction: .down)
        assert(stavePositions: [[3, -3]], direction: .down)
        assert(stavePositions: [[-3, 3]], direction: .down)
        assert(stavePositions: [[4, -4]], direction: .down)
        assert(stavePositions: [[-4, 4]], direction: .down)
        assert(stavePositions: [[5, -5]], direction: .down)
        assert(stavePositions: [[-5, 5]], direction: .down)
    }
    
    // MARK: - Chords (Three or note note heads)
    
    func test_Chords() {
        
        // The stem direction of the chord is determined by whichever of the chord's outer
        // notes is furthest fro the centre of the stave
        assert(stavePositions: [[6, -1, -3, -5]], direction: .down)
        assert(stavePositions: [[1, 3, -5]], direction: .up)
    }
    

   
}

// MARK: - Assert

extension StemDirectionDecider_MultipleNoteHeadTests {
    
    func assert(stavePositions: [[Int]], direction: StemDirection, file: StaticString = #file, line: UInt = #line) {
        let notes = stavePositions.map(TestNote.init)
        decider.process(noteCluster: notes)
        XCTAssertEqual(notes.map { $0.stemDirection }, Array(repeating: direction, count: notes.count), file: file, line: line)
    }
}

