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
    let leadingBarline = Barline()
    var trailingBarline: Barline?
    var timeSignature: TimeSignature?

    var duration: Time {
        return sequences.map { $0.duration }.max() ?? .zero
    }
    
    public init() {}
    
    public func add(sequence: NoteSequence) {
        self.sequences.append(sequence)
    }
}
