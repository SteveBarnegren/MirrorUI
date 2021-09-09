import Foundation

class PositionArticulationMarksProcessingOperation: CompositionProcessingOperation {
    
    func process(composition: Composition) {
        for stave in composition.staves {
            stave.forEachNote {
                self.process(note: $0, clef: stave.clef)
            }
        }
    }

    private func process(note: Note, clef: Clef) {

        let aboveArticulations = aboveArticulations(forNote: note)
        if !aboveArticulations.isEmpty {
            switch note.stemDirection {
                case .up:
                    let position = note.stemConnectingNoteHead.stavePosition + StavePosition(location: 5)
                    self.postion(articulations: aboveArticulations,
                                 startLocation: position,
                                 up: true)
                case .down:
                    self.postion(articulations: aboveArticulations,
                                 startLocation: note.stemConnectingNoteHead.stavePosition,
                                 up: true)
            }
        }

        let belowArticulations = belowArticulations(forNote: note)
        if !belowArticulations.isEmpty {
            switch note.stemDirection {
                case .up:
                    self.postion(articulations: belowArticulations,
                                 startLocation: note.stemConnectingNoteHead.stavePosition,
                                 up: false)
                case .down:
                    self.postion(articulations: belowArticulations,
                                 startLocation: note.stemConnectingNoteHead.stavePosition - StavePosition(location: 5),
                                 up: false)
            }
        }
    }
    
    private func postion(articulations: [ArticulationMark], startLocation: StavePosition, up: Bool) {
        
        let spaceOffset: Int
        let lineRounding: StaveSpace.LineRounding
        if up {
            spaceOffset = 1
            lineRounding = .spaceAbove
        } else {
            spaceOffset = -1
            lineRounding = .spaceBelow
        }
        
        var staveSpace = StaveSpace(stavePosition: startLocation,
                                    lineRounding: lineRounding)
        staveSpace = staveSpace.adding(spaces: spaceOffset)
        
        for articulation in articulations {
            articulation.stavePosition = staveSpace.stavePosition
            staveSpace = staveSpace.adding(spaces: spaceOffset)
        }
    }

    private func aboveArticulations(forNote note: Note) -> [ArticulationMark] {
        return note.articulationMarks.sortedAscendingBy(\.priorty).filter {
            switch $0.orientation {
                case .above:
                    return true
                case .below:
                    return false
                case .byNoteHead:
                    return note.stemDirection == .down
                case .byStem:
                    return note.stemDirection == .up
            }
        }
    }

    private func belowArticulations(forNote note: Note) -> [ArticulationMark] {
        return note.articulationMarks.sortedAscendingBy(\.priorty).filter {
            switch $0.orientation {
                case .above:
                    return false
                case .below:
                    return true
                case .byNoteHead:
                    return note.stemDirection == .up
                case .byStem:
                    return note.stemDirection == .down
            }
        }
    }

}
