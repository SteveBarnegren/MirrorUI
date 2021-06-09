//
//  GenerateTimeSignatureSymbolsProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 09/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateTimeSignatureSymbolsProcessingOperation: CompositionProcessingOperation {

    func process(composition: Composition) {
        composition.staves.forEach(process)
    }

    private func process(stave: Stave) {

        var lastTimeSignature: TimeSignature?

        for bar in stave.bars {
            if bar.timeSignature != lastTimeSignature {
                bar.timeSignatureSymbol = TimeSignatureSymbol(timeSignature: bar.timeSignature)
            }
            lastTimeSignature = bar.timeSignature
        }
    }
}
