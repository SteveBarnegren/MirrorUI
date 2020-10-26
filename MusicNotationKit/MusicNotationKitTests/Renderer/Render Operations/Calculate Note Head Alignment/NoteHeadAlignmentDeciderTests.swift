//
//  NoteHeadAlignmentDeciderTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 06/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

private class TestNote {
    let noteHeads: [TestNoteHead]
    let stemDirection: StemDirection
    
    init(noteHeads: [TestNoteHead], stemDirection: StemDirection) {
        self.noteHeads = noteHeads
        self.stemDirection = stemDirection
    }
}

private class TestNoteHead {
    var staveOffset: Int
    var alignment = NoteHeadAlignment.center
    
    init(staveOffset: Int) {
        self.staveOffset = staveOffset
    }
}

class NoteHeadAlignmentDeciderTests: XCTestCase {
    
    private var decider: NoteHeadAlignmentDecider<TestNote>!
    
    override func setUp() {
        super.setUp()
        
        let transformer =
            NoteHeadAlignmentDecider<TestNote>.Transformer<TestNote>.init(noteHeadStavePositions: { (note) -> [Int] in
                note.noteHeads.map { $0.staveOffset }
            }, stemDirection: { (note) -> StemDirection in note.stemDirection },
               setNoteHeadAlignmentForIndex: { (note, index, alignment) in
                note.noteHeads[index].alignment = alignment
            })
        
        decider = NoteHeadAlignmentDecider(transformer: transformer)
    }
    
    // MARK: - Single note
    
    func test_SingleNote_HasCenterAlignment() {
        assert(stavePostions: [1], stemDirection: .down, resultsIn: [.center])
        assert(stavePostions: [-1], stemDirection: .up, resultsIn: [.center])
    }
    
    // MARK: - Two Notes
    
    func test_NotesTwoStavePositionsApart_HaveCenterAlignment() {
        assert(stavePostions: [1, 3], stemDirection: .down, resultsIn: [.center, .center])
        assert(stavePostions: [-1, -3], stemDirection: .up, resultsIn: [.center, .center])
    }
    
    func test_TwoNotesOneStavePositionsApart_AlignOtherSideOfStem() {
        assert(stavePostions: [-3, -2], stemDirection: .up, resultsIn: [.center, .rightOfStem])
        assert(stavePostions: [-2, -1], stemDirection: .up, resultsIn: [.center, .rightOfStem])
        assert(stavePostions: [0, 1], stemDirection: .down, resultsIn: [.leftOfStem, .center])
        assert(stavePostions: [3, 4], stemDirection: .down, resultsIn: [.leftOfStem, .center])
    }
    
    // MARK: - Several Overlapping notes
    
    func testOddNumberOfMultipleAdjacentNotes() {
        // The majority of notes should fall on the 'correct' side of the stem. This
        // results in the lowest note being on the left side for up-stems and the right
        // side for down-stems.
        assert(stavePostions: [-1, -2, -3], stemDirection: .up, resultsIn: [.center, .rightOfStem, .center])

        assert(stavePostions: [-1, -2, -3], stemDirection: .up, resultsIn: [.center, .rightOfStem, .center])
        
        assert(stavePostions: [-4, -3, -2, -1, 0, 1, 2],
               stemDirection: .up,
               resultsIn: [.center, .rightOfStem, .center, .rightOfStem, .center, .rightOfStem, .center])

        assert(stavePostions: [1, 2, 3], stemDirection: .down, resultsIn: [.center, .leftOfStem, .center])
        
        assert(stavePostions: [2, 3, 4, 5, 6],
               stemDirection: .down,
               resultsIn: [.center, .leftOfStem, .center, .leftOfStem, .center])
        
        // Different arrangements to ensure a certain order isn't depended on
        assert(stavePostions: [-1, -2, -3], stemDirection: .up, resultsIn: [.center, .rightOfStem, .center])
        assert(stavePostions: [-3, -2, -1], stemDirection: .up, resultsIn: [.center, .rightOfStem, .center])
        assert(stavePostions: [-2, -1, -3], stemDirection: .up, resultsIn: [.rightOfStem, .center, .center])

    }
    
    func testEvenNumberOfMultipleAdjacentNotes() {
        // When there is an even number of adjacent notes, the lowest note always goes on the left side
        assert(stavePostions: [-3, -2, -1, 0],
               stemDirection: .up,
               resultsIn: [.center, .rightOfStem, .center, .rightOfStem])
        
        assert(stavePostions: [-4, -3, -2, -1, 0, 1, 2, 3],
               stemDirection: .up,
               resultsIn: [.center, .rightOfStem, .center, .rightOfStem, .center, .rightOfStem, .center, .rightOfStem])
        
        assert(stavePostions: [1, 2, 3, 4],
               stemDirection: .down,
               resultsIn: [.leftOfStem, .center, .leftOfStem, .center])
        
        assert(stavePostions: [2, 3, 4, 5, 6, 7],
               stemDirection: .down,
               resultsIn: [.leftOfStem, .center, .leftOfStem, .center, .leftOfStem, .center])
    }
    
    // MARK: - Multiple clusters
    
    func testMultipleNoteClusters() {
        
        // Note cluster - 2 sets of odd numbered clusters
        assert(stavePostions: [-3, -2, -1, 1, 2, 3],
               stemDirection: .down,
               resultsIn: [.center, .leftOfStem, .center, .center, .leftOfStem, .center])
        
        // Note cluster -  odd numbered clusters with isolated notes on either side
        assert(stavePostions: [-6, -3, -2, -1, 1],
               stemDirection: .up,
               resultsIn: [.center, .center, .rightOfStem, .center, .center])
    }
    
    func assert(stavePostions: [Int],
                stemDirection: StemDirection,
                resultsIn alignments: [NoteHeadAlignment],
                file: StaticString = #file,
                line: UInt = #line) {
        
        let noteHeads = stavePostions.map(TestNoteHead.init)
        let note = TestNote(noteHeads: noteHeads, stemDirection: stemDirection)
        
        decider.process(note: note)
        
        XCTAssertEqual(note.noteHeads.map { $0.alignment }, alignments, file: file, line: line)
    }
}
