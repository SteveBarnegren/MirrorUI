//
//  Bar.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public class Bar {
    var sequences = [NoteSequence]()
    
    var duration: Time {
        return sequences.reduce(Time.zero) { $0 + $1.duration }
    }
    
    public init() {}
    
    public func add(sequence: NoteSequence) {
        self.sequences.append(sequence)
    }
}

