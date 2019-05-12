//
//  NoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteRenderer {
    
    private let preferredStemHeight = 3.5
    private let stemXOffet = 0.55
    private let stemWidth = 0.1
    private let beamWidth = 0.3
    private let noteHeadWidth = 1.4
    
    func paths(forNotes notes: [Note]) -> [Path] {
        
        var paths = [Path]()
        
        var noteCluster = [Note]()
        
        func renderNoteCluster() {
            
            guard noteCluster.isEmpty == false else {
                return
            }
            
            paths += makePaths(forNoteCluster: noteCluster)
            noteCluster.removeAll()
        }
        
        var lastNoteWasConnected = false
        for note in notes {
            // Is is the first note of the cluster?
            if note.symbolDescription.numberOfForwardBeamConnections > 0 && lastNoteWasConnected == false {
                renderNoteCluster()
                noteCluster.append(note)
            }
                // Is it the middle of the cluster?
            else if note.symbolDescription.numberOfForwardBeamConnections > 0 && lastNoteWasConnected == true {
                noteCluster.append(note)
            }
                // Is the end of the cluster?
            else if note.symbolDescription.numberOfForwardBeamConnections == 0 && lastNoteWasConnected == true {
                noteCluster.append(note)
                renderNoteCluster()
            }
                // Otherwise it's an unconnected note
            else {
                paths += makePaths(forNote: note)
            }
            lastNoteWasConnected = note.symbolDescription.numberOfForwardBeamConnections > 0
        }
        renderNoteCluster()
        
        return paths
    }
    
    // MARK: - Isolated Notes
    
    private func makePaths(forNote note: Note) -> [Path] {
        
        var paths = [Path]()
        paths.append(maybe: makeHeadPath(forNote: note))
        
        // Crotchet
        if note.symbolDescription.numberOfBeams == 0 {
            paths.append(maybe: makeStemPath(forNote: note, to: note.position.y + preferredStemHeight))
        }
        
        // Quaver
        if note.symbolDescription.numberOfBeams == 1 {
            paths.append(maybe: makeStemPath(forNote: note, to: note.position.y + preferredStemHeight))

            var noteTailPath = Path(commands: makeQuaverTailCommands()).translated(x: note.xPosition + stemXOffet, y: note.yPosition + 1.75)
            noteTailPath.drawStyle = .fill
            paths.append(noteTailPath)
        }
        
        // Semiquaver or faster
        if note.symbolDescription.numberOfBeams >= 2 {
            
            let bottomOffset = 2.2
            let eachTailYOffset = 0.5
            let tailsHeight = eachTailYOffset * Double(note.symbolDescription.numberOfBeams)
            let stemHeight = max(preferredStemHeight, tailsHeight + bottomOffset)

            paths.append(maybe: makeStemPath(forNote: note, to: note.position.y + stemHeight))
            
            for (tailNumber, isLast) in (0..<note.symbolDescription.numberOfBeams).enumeratedWithLastItemFlag() {
                let yOffset = Double(tailNumber) * eachTailYOffset
                let commands = isLast ? makeFastNoteBottomTailCommands() : makeFastNoteTailCommands()
                var noteTailPath = Path(commands: commands).translated(x: note.xPosition + stemXOffet,
                                                                       y: note.yPosition + stemHeight - yOffset)
                noteTailPath.drawStyle = .fill
                paths.append(noteTailPath)
            }
        }
      
        return paths
    }
    
    private func makeQuaverTailCommands() -> [Path.Command] {
        // A note tail, anchored to the left
        let commands: [Path.Command] = [
            .move(Point(0.028177234195949308, 0.22361714423650725)),
            .curve(Point(0.1796576688116412, -0.26326044118239594), c1: Point(0.36589881412387104, 0.13806570405953167), c2: Point(0.21003653045372273, -0.15850308628952214)),
            .curve(Point(0.028177234195949308, 0.5), c1: Point(0.4571075440584742, 0.11569020480229597), c2: Point(0.03196085061274678, 0.27025900632689404)),
            .close,
        ].scaled(3.5)
        return commands
    }
    
    /*
 
     private func makeSemiquaverTailCommands() -> [Path.Command] {
     let commands: [Path.Command] = [
     .move(Point(-0.011953650817135536, 0.5)),
     .move(Point(-0.010231271761005828, -0.30435101921258434)),
     .curve(Point(-0.16237475505246537, -0.30578633509269243), c1: Point(-0.027451387913650066, -0.28099206852324476), c2: Point(-0.09987379874536026, -0.2657916829469805)),
     .curve(Point(-0.24074300210636812, -0.45218855486371956), c1: Point(-0.2248757113595705, -0.3457810790986207), c2: Point(-0.2623968434602474, -0.4126600014556503)),
     .curve(Point(-0.06850509649339503, -0.47457948259340604), c1: Point(-0.21602571439820245, -0.49730928266112256), c2: Point(-0.13385803693680196, -0.5214606195764981)),
     .curve(Point(0.008714897856421211, -0.38415458214659515), c1: Point(-0.021245127978170797, -0.44067736743536073), c2: Point(0.0014786093152681645, -0.3971155075090256)),
     .line(Point(0.008714897856421211, 0.026058696388302383)),
     .curve(Point(0.1792304244132646, -0.35229056960819516), c1: Point(0.18226080108967335, -0.08849347359720644), c2: Point(0.2675874595303402, -0.11050336514956877)),
     .curve(Point(0.21425213188790243, -0.0930725216606707), c1: Point(0.26596924995952503, -0.24026207534583588), c2: Point(0.2597177947976131, -0.16797185136542003)),
     .curve(Point(0.21683570047209705, 0.026919885916367292), c1: Point(0.2210403262938127, -0.04268545684726699), c2: Point(0.2213882927932591, -0.004074871766974408)),
     .curve(Point(0.008714897856421211, 0.47043249286977296), c1: Point(0.26652610659089887, 0.3143767472671014), c2: Point(0.09128345330187237, 0.28968343507539696)),
     .line(Point(0.008714897856421211, 0.49856468411989197)),
     .line(Point(-0.011953650817135536, 0.5)),
     .close,
     .move(Point(0.008714897856421211, 0.33264216837939453)),
     .curve(Point(0.20363079437510245, 0.07543356266402135), c1: Point(0.18302654785297456, 0.23858573044246678), c2: Point(0.19905633932245465, 0.14641103985097426)),
     .curve(Point(0.008714897856421211, 0.3082417984175567), c1: Point(0.16985480329407404, 0.15394531374787002), c2: Point(0.08875637875071873, 0.17787456940425372)),
     .line(Point(0.008714897856421211, 0.33264216837939453)),
     .close,
     .move(Point(0.008714897856421211, 0.19140708577675658)),
     .curve(Point(0.2059272997832754, -0.07986761556367605), c1: Point(0.18538248682111114, 0.04105231380363639), c2: Point(0.1846982200696919, 0.07654361989015901)),
     .curve(Point(0.008714897856421211, 0.19140708577675658), c1: Point(0.15769398041585103, -0.0070288758595288825), c2: Point(0.07567144209624721, 0.07066417104630607)),
     .close,
     ].scaled(5)
     return commands
     }
 */
    
    private func makeSemiquaverTailCommandsssssss() -> [Path.Command] {
        let commands: [Path.Command] = [
            .move(Point(0.008714897856421211, 0.026058696388302383)), // 1
            .curve(Point(0.1792304244132646, -0.35229056960819516), c1: Point(0.18226080108967335, -0.08849347359720644), c2: Point(0.2675874595303402, -0.11050336514956877)), //2
            .curve(Point(0.21425213188790243, -0.0930725216606707), c1: Point(0.26596924995952503, -0.24026207534583588), c2: Point(0.2597177947976131, -0.16797185136542003)), // 3
            .curve(Point(0.21683570047209705, 0.026919885916367292), c1: Point(0.2210403262938127, -0.04268545684726699), c2: Point(0.2213882927932591, -0.004074871766974408)), // 4
            .curve(Point(0.008714897856421211, 0.47043249286977296), c1: Point(0.26652610659089887, 0.3143767472671014), c2: Point(0.09128345330187237, 0.28968343507539696)), // 5
            .line(Point(0.008714897856421211, 0.49856468411989197)), // 6
            .line(Point(-0.011953650817135536, 0.5)), // 7
            .close, // 8
            .move(Point(0.008714897856421211, 0.33264216837939453)), // 9
            .curve(Point(0.20363079437510245, 0.07543356266402135), c1: Point(0.18302654785297456, 0.23858573044246678), c2: Point(0.19905633932245465, 0.14641103985097426)), // 10
            .curve(Point(0.008714897856421211, 0.3082417984175567), c1: Point(0.16985480329407404, 0.15394531374787002), c2: Point(0.08875637875071873, 0.17787456940425372)), // 11
            .line(Point(0.008714897856421211, 0.33264216837939453)), // 12
            .close, //13
            .move(Point(0.008714897856421211, 0.19140708577675658)), // 14
            .curve(Point(0.2059272997832754, -0.07986761556367605), c1: Point(0.18538248682111114, 0.04105231380363639), c2: Point(0.1846982200696919, 0.07654361989015901)), // 15
            .curve(Point(0.008714897856421211, 0.19140708577675658), c1: Point(0.15769398041585103, -0.0070288758595288825), c2: Point(0.07567144209624721, 0.07066417104630607)), //16
            .close, // 17
        ].scaled(3.5)
        return commands
    }
    
    // all tails
    private func makeFastNoteTailCommands() -> [Path.Command] {
        let commands: [Path.Command] = [
            .move(Point(0.008714897856421211, 0.19140708577675658)), // 14
            .curve(Point(0.2059272997832754, -0.07986761556367605), c1: Point(0.18538248682111114, 0.04105231380363639), c2: Point(0.1846982200696919, 0.07654361989015901)), // 15
            .line(Point(0.21425213188790243, -0.0930725216606707)), // 3
            .curve(Point(0.21683570047209705, 0.026919885916367292), c1: Point(0.2210403262938127, -0.04268545684726699), c2: Point(0.2213882927932591, -0.004074871766974408)), // 4
            .line(Point(0.20363079437510245, 0.07543356266402135)), // 10
            .curve(Point(0.008714897856421211, 0.3082417984175567), c1: Point(0.16985480329407404, 0.15394531374787002), c2: Point(0.08875637875071873, 0.17787456940425372)), // 11
            .close
            ].translated(x: -0.008714897856421211, y: -0.3082417984175567).scaled(4.2)
        return commands
    }
    
    // last tails
    private func makeFastNoteBottomTailCommands() -> [Path.Command] {
        let commands: [Path.Command] = [
            .move(Point(0.008714897856421211, 0.026058696388302383)), // 1
            .curve(Point(0.1792304244132646, -0.35229056960819516), c1: Point(0.18226080108967335, -0.08849347359720644), c2: Point(0.2675874595303402, -0.11050336514956877)), //2
            .curve(Point(0.21425213188790243, -0.0930725216606707), c1: Point(0.26596924995952503, -0.24026207534583588), c2: Point(0.2597177947976131, -0.16797185136542003)), // 3
            .line(Point(0.2059272997832754, -0.07986761556367605)), // 15
            .curve(Point(0.008714897856421211, 0.19140708577675658), c1: Point(0.15769398041585103, -0.0070288758595288825), c2: Point(0.07567144209624721, 0.07066417104630607)), //16
            ].translated(x: -0.008714897856421211, y: -0.19140708577675658).scaled(4.2)
        return commands
    }
    
    // MARK: - Note Clusters (connected with beams)
    
    private func makePaths(forNoteCluster notes: [Note]) -> [Path] {
        
        var paths = [Path]()
        
        // Work out the beam height
        let beamY = notes.map { $0.position.y }.max().orZero() + preferredStemHeight
        
        var previousNote: Note?
        
        // Draw notes with stems
        for note in notes {
            var notePaths = [Path]()
            
            notePaths.append(maybe: makeHeadPath(forNote: note))
            notePaths.append(maybe: makeStemPath(forNote: note, to: beamY))
            
            // Draw beam connections from the previous note
            if let previousNote = previousNote {
                for beam in previousNote.symbolDescription.beams where beam.style == .connectedToNext {
                    notePaths.append(makeBeamPath(fromNote: previousNote, toNote: note, beamYPosition: beamY, beamIndex: beam.index))
                }
            }
            
            // Draw cutoff beam connections
            for beam in note.symbolDescription.beams where beam.style == .cutOffLeft {
                notePaths.append(makeCutOffBeamPath(forNote: note, beamYPosition: beamY, beamIndex: beam.index, rightSide: false))
            }
            for beam in note.symbolDescription.beams where beam.style == .cutOffRight {
                notePaths.append(makeCutOffBeamPath(forNote: note, beamYPosition: beamY, beamIndex: beam.index, rightSide: true))
            }
            
            paths += notePaths
            
            previousNote = note
        }
        
        return paths
    }
    
    private func makeBeamPath(fromNote: Note, toNote: Note, beamYPosition: Double, beamIndex: Int) -> Path {
        
        let beamSeparation = 0.4
        
        let beamStartX = fromNote.position.x + stemXOffet
        let beamEndX = toNote.position.x + stemXOffet + stemWidth
        let beamRect = Rect(x: beamStartX,
                            y: beamYPosition - (Double(beamIndex) * (beamSeparation + beamWidth)),
                            width: beamEndX - beamStartX,
                            height: -beamWidth)
        
        var path = Path()
        path.addRect(beamRect)
        path.drawStyle = .fill
        return path
    }
    
    private func makeCutOffBeamPath(forNote note: Note, beamYPosition: Double, beamIndex: Int, rightSide: Bool) -> Path {
        
        let beamSeparation = 0.4
        
        let x: Double
        if rightSide {
            x = note.position.x + stemXOffet + stemWidth
        } else {
            x = note.position.x + stemXOffet - 1
        }
        
        let beamRect = Rect(x: x,
                            y: beamYPosition - (Double(beamIndex) * (beamSeparation + beamWidth)),
                            width: 1,
                            height: -beamWidth)
        
        var path = Path()
        path.addRect(beamRect)
        path.drawStyle = .fill
        return path
    }
    
    // MARK: - Components
    
    private func makeHeadPath(forNote note: Note) -> Path? {
        
        let path: Path
        
        switch note.symbolDescription.headStyle {
        case .semibreve:
            path = SymbolPaths.semibreve
        case .open:
            path = SymbolPaths.openNoteHead
        case .filled:
            path = SymbolPaths.filledNoteHead
        case .none:
            return nil
        }
        
        return path.translated(x: note.position.x - noteHeadWidth/2, y: note.position.y)
    }
    
    private func makeStemPath(forNote note: Note, to stemEndY: Double) -> Path? {
        
        if note.symbolDescription.hasStem == false {
            return nil
        }
        
        guard let stemRect = self.stemRect(fromNote: note, to: stemEndY) else {
            return nil
        }
        
        var stemPath = Path()
        stemPath.addRect(stemRect)
        stemPath.drawStyle = .fill
        return stemPath
    }
    
    private func stemRect(fromNote note: Note, to stemEndY: Double) -> Rect? {
        
        if note.symbolDescription.hasStem == false {
            return nil
        }
        
        let stemYOffset = 0.6
        
        return Rect(x: note.position.x + stemXOffet,
                    y: note.position.y + stemYOffset,
                    width: stemWidth,
                    height: stemEndY - note.position.y - stemYOffset)
    }
}
