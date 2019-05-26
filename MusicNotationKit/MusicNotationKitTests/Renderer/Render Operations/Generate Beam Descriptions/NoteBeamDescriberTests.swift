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
                                    numberOfTails: { $0.numberOfTails },
                                    setBeams: { note, beams in note.beams = beams})
        self.beamDescriber = NoteBeamDescriber(beaming: beaming)
    }

    // MARK: - Crotchets
    
    func test_FourCrotchetsHaveNoBeams() {
        
        let notes = [
            Note(time: .zero, numberOfTails: 0),
            Note(time: .init(crotchets: 1), numberOfTails: 0),
            Note(time: .init(crotchets: 2), numberOfTails: 0),
            Note(time: .init(crotchets: 3), numberOfTails: 0)
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
            Note(time: .zero, numberOfTails: 1),
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [])
    }
    
    func test_TwoQuaversAreBeamed() {
        
        let notes = [
            Note(time: .zero, numberOfTails: 1),
            Note(time: .init(quavers: 1), numberOfTails: 1),
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedNext])
        notes[1].verify(beams: [.connectedPrevious])
    }
    
    func test_ThreeQuaversAreBeamedCorrectly() {
        
        let notes = [
            Note(time: .zero, numberOfTails: 1),
            Note(time: .init(quavers: 1), numberOfTails: 1),
            Note(time: .init(quavers: 2), numberOfTails: 1),
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedNext])
        notes[1].verify(beams: [.connectedPrevious])
        notes[2].verify(beams: [])
    }
    
    func test_FourQuaversAreBeamedInGroupsOfTwo() {
        
        let notes = [
            Note(time: .zero, numberOfTails: 1),
            Note(time: .init(quavers: 1), numberOfTails: 1),
            Note(time: .init(quavers: 2), numberOfTails: 1),
            Note(time: .init(quavers: 3), numberOfTails: 1),
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedNext])
        notes[1].verify(beams: [.connectedPrevious])
        notes[2].verify(beams: [.connectedNext])
        notes[3].verify(beams: [.connectedPrevious])
    }
    
    // MARK: - Semiquavers
    
    func test_FourSemiQuaversAreBeamed() {
        
        let notes = [
            Note(time: .zero, numberOfTails: 2),
            Note(time: .init(semiquavers: 1), numberOfTails: 2),
            Note(time: .init(semiquavers: 2), numberOfTails: 2),
            Note(time: .init(semiquavers: 3), numberOfTails: 2),
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedNext, .connectedNext])
        notes[1].verify(beams: [.connectedBoth, .connectedBoth])
        notes[2].verify(beams: [.connectedBoth, .connectedBoth])
        notes[3].verify(beams: [.connectedPrevious, .connectedPrevious])
    }
    
    // MARK: - Quaver / SemiQuaver groupings
    
    func test_8th_16th_16th() {
        
        let notes = [
            Note(time: .init(semiquavers: 0), numberOfTails: 1), // 8th
            Note(time: .init(semiquavers: 2), numberOfTails: 2), // 16th
            Note(time: .init(semiquavers: 3), numberOfTails: 2)  // 16th
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedNext])
        notes[1].verify(beams: [.connectedBoth, .connectedNext])
        notes[2].verify(beams: [.connectedPrevious, .connectedPrevious])
    }
    
    func test_16th_8th_16th() {
        
        let notes = [
            Note(time: .init(semiquavers: 0), numberOfTails: 2), // 16th
            Note(time: .init(semiquavers: 1), numberOfTails: 1), // 8th
            Note(time: .init(semiquavers: 3), numberOfTails: 2)  // 16th
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedNext, .cutOffRight])
        notes[1].verify(beams: [.connectedBoth])
        notes[2].verify(beams: [.connectedPrevious, .cutOffLeft])
    }
    
    func test_16th_16th_8th() {
        
        let notes = [
            Note(time: .init(semiquavers: 0), numberOfTails: 2), // 16th
            Note(time: .init(semiquavers: 1), numberOfTails: 2), // 16th
            Note(time: .init(semiquavers: 2), numberOfTails: 1)  // 8th
        ]
        beamDescriber.applyBeams(to: notes)
        notes[0].verify(beams: [.connectedNext, .connectedNext])
        notes[1].verify(beams: [.connectedBoth, .connectedPrevious])
        notes[2].verify(beams: [.connectedPrevious])
    }
    
    
}

// MARK: - Test Type

fileprivate class Note {
    var time: Time
    var numberOfTails: Int
    var beams = [Beam]()
    
    init(time: Time, numberOfTails: Int) {
        self.time = time
        self.numberOfTails = numberOfTails
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
