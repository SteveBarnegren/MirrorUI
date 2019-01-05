//
//  Note.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

public class Note {
    
    public enum Value {
        case whole
        case half
        case quarter
        case eighth
        case sixteenth
    }
    
    let value: Value
    let pitch: Pitch
    var symbolDescription = NoteSymbolDescription.standard
    var time = Time.zero
    
    var duration: Time {
        switch self.value {
        case .whole: return Time(crotchets: 4)
        case .half: return Time(crotchets: 2)
        case .quarter: return Time(crotchets: 1)
        case .eighth: return Time(quavers: 1)
        case .sixteenth: return Time(semiquavers: 1)
        }
    }
    
    public init(value: Value, pitch: Pitch) {
        self.value = value
        self.pitch = pitch
    }
}

class NoteSymbolDescription {
    
    enum HeadStyle {
        case none
        case semibreve
        case open
        case filled
    }
    
    enum BeamStyle {
        case connectedToNext
        case cutOffLeft
        case cutOffRight
    }
    
    struct Beam {
        let index: Int
        let style: BeamStyle
    }
    
    let headStyle: HeadStyle
    let hasStem: Bool
    let numberOfBeams: Int
    var beams = [Beam]()
    
    init(headStyle: HeadStyle, hasStem: Bool, numberOfBeams: Int) {
        self.headStyle = headStyle
        self.hasStem = hasStem
        self.numberOfBeams = numberOfBeams
    }
    
    static var standard: NoteSymbolDescription {
        return NoteSymbolDescription(headStyle: .none, hasStem: false, numberOfBeams: 0)
    }
    
    var numberOfForwardBeamConnections: Int {
        
        var num = 0
        
        for beam in beams {
            if beam.style == .connectedToNext {
                num += 1
            }
        }
        
        return num
    }
}
