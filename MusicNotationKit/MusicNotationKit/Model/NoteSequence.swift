//
//  NoteSequence.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public struct TupletTime: Equatable {
    var numerator: Int
    var denominator: Int
    
    public init(value: Int, over: Int) {
        self.numerator = value
        self.denominator = over
    }
}

public class NoteSequence {
    
    enum Item {
        case note(Note)
        case rest(Rest)
        case startTuplet(TupletTime)
        case endTuplet

        var playable: Playable? {
            switch self {
            case .note(let n):
                return n
            case .rest(let r):
                return r
            default:
                return nil
            }
        }
    }
    
    var items = [Item]()
    var playables: [Playable] {
        return items.compactMap { $0.playable }
    }
    var notes: [Note] {
        return playables.compactMap { $0 as? Note }
    }
    var rests: [Rest] {
        return playables.compactMap { $0 as? Rest }
    }
    var ties: [VariationSet<Tie>] {
        return notes.map { note in
            note.noteHeads.compactMap { $0.tie }
        }.joined().toArray()
    }
    
    var duration: Time {
        return playables.reduce(Time.zero) { $0 + $1.duration }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Add Playable items
    
    public func add(note: Note) {
        self.items.append(.note(note))
    }
    
    public func add(rest: Rest) {
        self.items.append(.rest(rest))
    }
    
    public func startTuplet(_ time: TupletTime) {
        self.items.append(.startTuplet(time))
    }
    
    public func endTuplet() {
        self.items.append(.endTuplet)
    }
}

extension NoteSequence {

    func calculateMaxY() -> Double {
        return notes.map { $0.calculateMaxY() }.max() ?? 0
    }
}

extension Note {

    func calculateMaxY() -> Double {
        max(stemEndY, stemConnectingNoteHead.yPosition)
    }
}
