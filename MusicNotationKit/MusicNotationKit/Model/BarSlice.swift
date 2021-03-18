//
//  BarSlice.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 14/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class BarSlice {
    
    var bars: [Bar]
    
    var shouldRenderClef = false {
        didSet {
            bars.forEach { $0.shouldRenderClef = shouldRenderClef }
        }
    }
    
    var leadingBarlines: [Barline] {
        bars.map { $0.leadingBarline }
    }
    
    var trailingBarlines: [Barline] {
        bars.compactMap { $0.trailingBarline }
    }
    
    lazy var sequences: [NoteSequence] = {
        bars.map { $0.sequences }.joined().toArray()
    }()
    
    lazy var clefSymbols: [ClefSymbol] = {
        bars.map { $0.clefSymbol }.toArray()
    }()
    
    var trailingTies: [Tie] {
        bars.map { $0.trailingTies }.joined().toArray() 
    }
    
    lazy var duration: Time = {
        bars.map { $0.duration }.max() ?? .zero 
    }()
    
    lazy var barNumber: Int = {
        bars.first!.barNumber
    }()
    
    var layoutAnchors = [LayoutAnchor]()
    var trailingBarlineAnchor: LayoutAnchor?
    
    var minimumWidth = Double(0)
    var preferredWidth = Double(0)
    
    init(bars: [Bar]) {
        self.bars = bars
    }
    
    func resetLayoutAnchors() {
        layoutAnchors.forEach { $0.reset() }
        trailingBarlineAnchor?.reset()
    }
}

extension BarSlice {
    
    func forEachNote(_ handler: (Note) -> Void) {
        bars.forEachNote(handler)
    }
}
