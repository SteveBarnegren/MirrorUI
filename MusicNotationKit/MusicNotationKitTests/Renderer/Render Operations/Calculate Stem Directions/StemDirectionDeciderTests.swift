//
//  StemDirectionDeciderTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 21/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

private class TestNote {
    var stavePosition: Int
    var stemDirection = StemDirection.up
    
    init(stavePosition: Int) {
        self.stavePosition = stavePosition
    }
}

class StemDirectionDeciderTests: XCTestCase {
    
    private var decider: StemDirectionDecider<TestNote>!
    
    override func setUp() {
        super.setUp()
        
        let transformer = StemDirectionDecider<TestNote>.Transformer<TestNote>(stavePosition: { $0.stavePosition },
                                                                               setStemDirection: { $0.stemDirection = $1 })
        decider = StemDirectionDecider(transformer: transformer)
    }
    
    // MARK: - Single note
    
    func test_BelowMiddleOfStave_UpwardsStem() {
        assert(stavePositions: [-1],
               direction: .up)
    }
    
    func test_AboveMiddleOfStave_DownwardsStem() {
        assert(stavePositions: [1],
               direction: .down)
    }
    
    func test_MiddleOfStave_DownwardsStem() {
        assert(stavePositions: [0],
               direction: .down)
    }
    
    // MARK: - Equal notes above and below
    
    // For clusters that have an equal number of notes above and below the line, the
    // note furthest from the center of the stave dictates the stem direction
    
    func test_EqualNotesAboveAndBelow() {
        // Examples taken from 'Behind Bars'
        
        // 2 Notes - The note in the top half of the stave is further from the middle that
        // the note in the bottom half
        assert(stavePositions: [5, -4],
               direction: .down)
        assert(stavePositions: [-3, 4],
               direction: .down)
        assert(stavePositions: [3, -2],
               direction: .down)
        assert(stavePositions: [-1, 2],
               direction: .down)
        
        // 2 Notes - The note in the bottom half of the stave is further from the middle
        // that the note in the top half
        assert(stavePositions: [4, -5],
               direction: .up)
        assert(stavePositions: [-4, 3],
               direction: .up)
        assert(stavePositions: [2, -3],
               direction: .up)
        assert(stavePositions: [-2, 1],
               direction: .up)
        
        // Six Notes (-4 is furthest from center)
        assert(stavePositions: [-2, -4, -2, 1, 3, 1],
               direction: .up)
        
        // 4 Notes (3 is furthest from center)
        assert(stavePositions: [3, 1, -1, -2],
                     direction: .down)
    }
    
    // MARK: - Unequal notes above and below

    // When there are unequal numbers of notes above and below the middle of the stave,
    // the majority of notes should go in the correct direction
    
    func test_UnequalNotesAboveAndBelow() {
        // Examples taken from 'Behind Bars'

        assert(stavePositions: [-1, 1, -1],
               direction: .up)
        
        assert(stavePositions: [2, 0, 1, -2],
               direction: .down)
        
        assert(stavePositions: [-1, -2, -3, 3],
                      direction: .up)
    }
    
    // MARK: - Equidistant Notes Above and Below
    
    // When the notes above and below are equidistant, no clear upwards / downwards
    // decision can be made. In this case downwards should be preferred
    
    func test_EquidistantNotesAboveAndBelow() {
        // Two notes
        assert(stavePositions: [1, -1], direction: .down)
        assert(stavePositions: [-1, 1], direction: .down)
        assert(stavePositions: [2, -2], direction: .down)
        assert(stavePositions: [-2, 2], direction: .down)
        assert(stavePositions: [3, -3], direction: .down)
        assert(stavePositions: [-3, 3], direction: .down)
        
        // Longer Grounpings
        assert(stavePositions: [2, -2, 2, -2, 2, -2], direction: .down)
        assert(stavePositions: [-2, 2, -2, 2, -2, 2], direction: .down)
        assert(stavePositions: [3, 0, -3], direction: .down)
        assert(stavePositions: [-3, 0, 3], direction: .down)
    }
}

// MARK: - Assertion

extension StemDirectionDeciderTests {
    
    func assert(stavePositions: [Int], direction: StemDirection, file: StaticString = #file, line: UInt = #line) {
        
        let notes = stavePositions.map(TestNote.init)
        decider.process(noteCluster: notes)
        XCTAssertEqual(notes.map { $0.stemDirection }, Array(repeating: direction, count: notes.count), file: file, line: line)
    }
}
