//
//  NoteBeamDescriberFourFourTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 11/08/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class NoteBeamDescriberFourFourTests: XCTestCase {
    
    private var beamDescriber: NoteBeamDescriber<Note>!
    
    override func setUp() {
        super.setUp()
        
        let beaming = Beaming<Note>(duration: { $0.duration },
                                    time: { $0.time },
                                    numberOfTails: { $0.numberOfTails },
                                    setBeams: { note, beams in note.beams = beams})
        self.beamDescriber = NoteBeamDescriber(beaming: beaming)
    }
    
    // MARK: - Crotchet Length Groupings
    
    func test_4() {
        assert(values: [4], beams:
            """
            |
            """
        )
    }
    
    func test_8_8() {
        assert(values: [8, 8], beams:
            """
            |--|
            """
        )
    }
    
  func test_8_16_16() {
        assert(values: [8, 16, 16], beams:
            """
            |--|--|
            |  |--|
            """
        )
    }
    
    func test_16_8_16() {
        assert(values: [16, 8, 16], beams:
            """
            |--|--|
            |- | -|
            """
        )
    }
    
    func test_16_16_8() {
        assert(values: [16, 16, 8], beams:
            """
            |--|--|
            |--|  |
            """
        )
    }
    
    func test_16_16_16_16() {
        assert(values: [16, 16, 16, 16], beams:
            """
            |--|--|--|
            |--|--|--|
            """
        )
    }
    
    // MARK: - Half bar groupings
    
    func test_4_4() {
        assert(values: [4, 4], beams:
            """
            |  |
            """
        )
    }
    
    func test_8_8_8_8() {
        assert(values: [8, 8, 8, 8], beams:
            """
            |--|--|--|
            """
        )
    }
    
    func test_16_16_16_16__16_16_16_16() {
        assert(values: [16, 16, 16, 16, 16, 16, 16, 16], beams:
            """
            |--|--|--|  |--|--|--|
            |--|--|--|  |--|--|--|
            """
        )
    }
    
    // MARK: - Full Bars
    
    func test_FullBar_8() {
        assert(values: [8, 8, 8, 8, 8, 8, 8, 8], beams:
            """
            |--|--|--|  |--|--|--|
            """
        )
    }

    
    
    // MARK: - Assertion
    
    func assert(values: [Int], beams: String, file: StaticString = #file, line: UInt = #line) {
        
        var currentTime = Time.zero
        var notes = [Note]()
        for value in values {
            
            let duration = Time(value: 1, division: value)
            let note = Note(duration: duration, time: currentTime, numberOfTails: tails(fromValue: value))
            notes.append(note)
            currentTime += duration
        }
        
        beamDescriber.applyBeams(to: notes)
        notes.verify(beams: beams, file: file, line: line)
    }
    
    private func tails(fromValue value: Int) -> Int {
        
        switch value {
        case 1: return 0
        case 2: return 0
        case 4: return 0
        case 8: return 1
        case 16: return 2
        case 32: return 3
        case 64: return 4
        default:
            fatalError()
        }
    }
}

// MARK: - Test Type

fileprivate class Note {
    var duration: Time
    var time: Time
    var numberOfTails: Int
    var beams = [Beam]()
    
    init(duration: Time, time: Time, numberOfTails: Int) {
        self.duration = duration
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

fileprivate extension Array where Element == Note {
    
    func verify(beams expectedBeamsString: String, file: StaticString = #file, line: UInt = #line) {
        
        let beamsString = string(fromNotes: self)
        if beamsString != expectedBeamsString {
            XCTFail("\nHave\n\(beamsString)\nExpected\n\(expectedBeamsString)", file: file, line: line)
        }
    }
}


// MARK: - Beam string helpers

fileprivate func string(fromNotes notes: [Note]) -> String {
    
    var string = ""
    let numBeams = notes.map { $0.beams.count }.max()!
    
    if numBeams == 0 {
        return notes.map { _ in "|" }.joined(separator: "  ")
    }
    
    for beamIndex in 0..<numBeams {
        if string.isEmpty == false {
            string += "\n"
        }
        
        var beamIndexString = ""
        for (noteIndex, note) in notes.enumerated() {
            let isFirstNote = noteIndex == 0
            let isLastNote = noteIndex == notes.count-1

            if let beam = note.beams[maybe: beamIndex] {
                switch beam {
                case .cutOffLeft, .connectedPrevious, .connectedBoth:
                    beamIndexString += "-"
                case .connectedNext, .cutOffRight:
                    if isFirstNote == false {
                        beamIndexString += " "
                    }
                }
            } else {
                if isFirstNote == false {
                    beamIndexString += " "
                }
            }
            
            beamIndexString += "|"
            
            if let beam = note.beams[maybe: beamIndex] {
                switch beam {
                case .connectedNext, .cutOffRight, .connectedBoth:
                    beamIndexString += "-"
                case .cutOffLeft, .connectedPrevious:
                    if !isLastNote {
                        beamIndexString += " "
                    }
                }
            }  else {
                if !isLastNote {
                    beamIndexString += " "
                }
            }
        }
        string += beamIndexString
    }
    
    return string
}


