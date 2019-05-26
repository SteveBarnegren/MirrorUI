//
//  NoteBeamDescriberTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 25/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class NoteBeamDescriberTests: XCTestCase {
    
    private var beamDescriber: NoteBeamDescriber<Note>!
    
    override func setUp() {
        super.setUp()
        
        let beaming = Beaming<Note>(time: { $0.time },
                                    numberOfBeams: { $0.numberOfBeams },
                                    beams: { $0.beams },
                                    setBeams: { note, beams in note.beams = beams})
        self.beamDescriber = NoteBeamDescriber(beaming: beaming)
    }

    // MARK: - Crotchets
    
    func test_FourCrotchetsHaveNoBeams() {
        
        let notes = [
            Note(time: .zero, numberOfBeams: 0),
            Note(time: .init(crotchets: 1), numberOfBeams: 0),
            Note(time: .init(crotchets: 2), numberOfBeams: 0),
            Note(time: .init(crotchets: 3), numberOfBeams: 0)
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [])
        notes[1].verify(beams: [])
        notes[2].verify(beams: [])
        notes[3].verify(beams: [])
    }
    
    // MARK: - Quavers
    
    func test_OneQuaverIsNotBeamed() {
        
        let notes = [
            Note(time: .zero, numberOfBeams: 1),
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.cutOffLeft])
    }
    
    func test_TwoQuaversAreBeamed() {
        
        let notes = [
            Note(time: .zero, numberOfBeams: 1),
            Note(time: .init(quavers: 1), numberOfBeams: 1),
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedToNext])
        notes[1].verify(beams: [])
    }
    
    func test_ThreeQuaversAreBeamedCorrectly() {
        
        let notes = [
            Note(time: .zero, numberOfBeams: 1),
            Note(time: .init(quavers: 1), numberOfBeams: 1),
            Note(time: .init(quavers: 2), numberOfBeams: 1),
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedToNext])
        notes[1].verify(beams: [])
        notes[2].verify(beams: [.cutOffLeft])
    }
    
    func test_FourQuaversAreBeamedInGroupsOfTwo() {
        
        let notes = [
            Note(time: .zero, numberOfBeams: 1),
            Note(time: .init(quavers: 1), numberOfBeams: 1),
            Note(time: .init(quavers: 2), numberOfBeams: 1),
            Note(time: .init(quavers: 3), numberOfBeams: 1),
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedToNext])
        notes[1].verify(beams: [])
        notes[2].verify(beams: [.connectedToNext])
        notes[3].verify(beams: [])
    }
    
    // MARK: - Semiquavers
    
    func test_FourSemiQuaversAreBeamed() {
        
        let notes = [
            Note(time: .zero, numberOfBeams: 2),
            Note(time: .init(semiquavers: 1), numberOfBeams: 2),
            Note(time: .init(semiquavers: 2), numberOfBeams: 2),
            Note(time: .init(semiquavers: 3), numberOfBeams: 2),
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedToNext, .connectedToNext])
        notes[1].verify(beams: [.connectedToNext, .connectedToNext])
        notes[2].verify(beams: [.connectedToNext, .connectedToNext])
        notes[3].verify(beams: [])
    }
}

// MARK: - Test Type

fileprivate class Note {
    var time: Time
    var numberOfBeams: Int
    var beams = [Beam]()
    
    init(time: Time, numberOfBeams: Int) {
        self.time = time
        self.numberOfBeams = numberOfBeams
    }
}

// MARK: - Note + Verify

extension Note {
    
    @discardableResult func verify(beams: [Beam], file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(self.beams, beams, file: file, line: line)
        return self
    }
}

/*
 // Inputs
 var time: (T) -> Time
 var numberOfBeams: (T) -> Int
 var beams: (T) -> [Beam]
 
 // Outputs
 var setBeams: (T, [Beam]) -> Void
 */

// MARK: - Helpers

extension NoteBeamDescriberTests {
    
//    func process(notes: [NoteValue]) -> NoteSequence {
//
//        return sequence
//    }

}
