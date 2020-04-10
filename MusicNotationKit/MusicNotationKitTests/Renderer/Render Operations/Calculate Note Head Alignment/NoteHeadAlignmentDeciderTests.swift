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
    
    func test_SingleNote_HasCenterAlignment() {
        assert(stavePostions: [1], stemDirection: .down, resultsIn: [.center])
        assert(stavePostions: [-1], stemDirection: .up, resultsIn: [.center])
    }
    
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