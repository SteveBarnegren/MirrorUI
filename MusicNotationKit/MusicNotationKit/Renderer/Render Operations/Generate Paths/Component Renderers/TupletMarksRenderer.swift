//
//  TupletMarksRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 30/10/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class TupletMarksRenderer {
    
    func paths(forNoteSequence noteSequence: NoteSequence) -> [Path] {
        
        var paths = [Path]()
        var tuplet: TupletTime?
        var tupletPlayables = [Playable]()
        
        for item in noteSequence.items {
            switch item {
            case .note(let note):
                if tuplet != nil {
                    tupletPlayables.append(note)
                }
            case .rest(let rest):
                if tuplet != nil {
                    tupletPlayables.append(rest)
                }
            case .startTuplet(let t):
                tuplet = t
            case .endTuplet:
                if let t = tuplet {
                    paths += self.paths(forTuplet: t, playables: tupletPlayables)
                }
                tuplet = nil
                tupletPlayables.removeAll()
            }
        }
        
        return paths
    }
    
    private func paths(forTuplet tuplet: TupletTime, playables: [Playable]) -> [Path] {
        
        let squareSize = 0.8
        let margin = 0.3
        
        if playables.isEmpty {
            return []
        }
        
        // x Position is the average of the notes in the tuplet
        let startX = self.startX(forPlayable: playables.first!)
        let endX = self.endX(forPlayable: playables.last!)
        let x = startX.lerp(to: endX, t: 0.5)
        
        // yPos is max / min y
        let position = markPosition(forPlayables: playables)
        var y = position.yPosition
        if position.placeAbove {
            y += margin
        } else {
            y -= margin
            y -= squareSize
        }
    
        var path = Path(rect: Rect(x: x - squareSize/2,
                                   y: y,
                                   width: squareSize,
                                   height: squareSize))
        path.drawStyle = .fill
        return [path]
    }
    
    private func startX(forPlayable playable: Playable) -> Double {
        
        if let note = playable as? Note {
            return note.stemCenterX - NoteMetrics.stemThickness/2
        } else if let rest = playable as? Rest {
            return rest.position.x - rest.leadingWidth
        }
        
        fatalError("Unknown playable type")
    }
    
    private func endX(forPlayable playable: Playable) -> Double {
        
        if let note = playable as? Note {
            return note.stemCenterX + NoteMetrics.stemThickness/2
        } else if let rest = playable as? Rest {
            return rest.position.x + rest.trailingWidth
        }
        
        fatalError("Unknown playable type")
    }
    
    private struct TupletMarkPosition {
        var yPosition: Double
        var placeAbove: Bool
    }
    
    private func markPosition(forPlayables playables: [Playable]) -> TupletMarkPosition {
        
        let placeAbove = playables.compactMap { $0 as? Note }.first?.symbolDescription.stemDirection.isUp ?? false
        
        var y = Double(0)
        
        for note in playables.compactMap({ $0 as? Note }) {
            y = placeAbove ? max(y, note.stemEndY) : min(y, note.stemEndY)
        }
        
        return TupletMarkPosition(yPosition: y, placeAbove: placeAbove)
    }
}
