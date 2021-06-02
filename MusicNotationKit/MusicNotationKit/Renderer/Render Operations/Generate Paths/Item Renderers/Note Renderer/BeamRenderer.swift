//
//  BeamRenderer.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 30/05/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class BeamRenderer<N> {

    // MARK: - Types

    struct Transformer {
        let beams: (N) -> [Beam]
        let stemDirection: (N) -> StemDirection
        let stemEndY: (N) -> Double
        let stemLeadingEdge: (N) -> Double
        let stemTrailingEdge: (N) -> Double
    }

    // MARK: - Properties

    private let tf: Transformer
    private let beamSeparation: Double
    private let beamThickness: Double

    // MARK: - Init

    init(transformer: Transformer, beamSeparation: Double, beamThickness: Double) {
        self.tf = transformer
        self.beamSeparation = beamSeparation
        self.beamThickness = beamThickness
    }

    // MARK: - Beam paths

    func beamPaths(forNotes notes: [N]) -> [Path] {

        if notes.isEmpty {
            return []
        }

        var paths = [Path]()
        let stemDirection = tf.stemDirection(notes.first!)

        let maxBeams = notes.map { tf.beams($0).count }.max() ?? 0
        var beamStartNotes = [N?](repeating: nil, count: maxBeams)

        for note in notes {
            for (beamIndex, beam) in tf.beams(note).enumerated() {
                switch beam {
                case .connectedNext:
                    beamStartNotes[beamIndex] = note
                case .connectedPrevious:
                    if let startNote = beamStartNotes[beamIndex] {
                        let path = makeBeamPath(fromNote: startNote, toNote: note, beamIndex: beamIndex)
                        paths.append(path)
                    }
                    beamStartNotes[beamIndex] = nil
                case .connectedBoth:
                    break
                case .cutOffLeft:
                    let beamY: Double
                    if stemDirection == .up {
                        beamY = notes.map { tf.stemEndY($0) }.max()!
                    } else {
                        beamY = notes.map { tf.stemEndY($0) }.min()!
                    }
                    let path = makeCutOffBeamPath(forNote: note, beamYPosition: beamY, beamIndex: beamIndex, rightSide: false)
                    paths.append(path)
                case .cutOffRight:
                    let beamY: Double
                    if stemDirection == .up {
                        beamY = notes.map { tf.stemEndY($0) }.max()!
                    } else {
                        beamY = notes.map { tf.stemEndY($0) }.min()!
                    }
                    let path = makeCutOffBeamPath(forNote: note, beamYPosition: beamY, beamIndex: beamIndex, rightSide: true)
                    paths.append(path)
                }
            }
        }

        return paths
    }

    private func makeBeamPath(fromNote: N, toNote: N, beamIndex: Int) -> Path {

        let stemDirection = tf.stemDirection(fromNote)

        let startX = tf.stemTrailingEdge(fromNote)
        let endX =  tf.stemLeadingEdge(toNote)
        let eachBeamYOffset = (beamSeparation + beamThickness).inverted(if: { stemDirection == .down })

        let thickness = beamThickness.inverted(if: { stemDirection == .down })
        let startY = tf.stemEndY(fromNote)
        let endY = tf.stemEndY(toNote)
        //let startY = fromNote.stemConnectingNoteHead.yPosition + fromNote.stemEndOffset
        //let endY = toNote.stemConnectingNoteHead.yPosition + toNote.stemEndOffset

        let startPoint = Vector2D(startX, startY - (Double(beamIndex) * eachBeamYOffset))
        let endPoint = Vector2D(endX, endY - (Double(beamIndex) * eachBeamYOffset))

        let commmands: [Path.Command] = [
            .move(startPoint),
            .line(Vector2D(startPoint.x, startPoint.y - thickness)),
            .line(Vector2D(endPoint.x, endPoint.y - thickness)),
            .line(endPoint),
            .close
        ]

        var path = Path(commands: commmands)
        path.drawStyle = .fill

        return path
    }

    private func makeCutOffBeamPath(forNote note: N, beamYPosition: Double, beamIndex: Int, rightSide: Bool) -> Path {

        let stemDirection = tf.stemDirection(note)
        let height = beamThickness
        let width = 0.85

        let x: Double
        if rightSide {
            x = tf.stemTrailingEdge(note)
        } else {
            x = tf.stemLeadingEdge(note) - width
        }

        let eachBeamYOffset = (beamSeparation + height).inverted(if: { stemDirection == .up })
        let beamRect = Rect(x: x,
                            y: beamYPosition + (Double(beamIndex) * eachBeamYOffset),
                            width: width,
                            height: height.inverted(if: { stemDirection == .up }))

        var path = Path(rect: beamRect)
        path.drawStyle = .fill
        return path
    }

}

extension BeamRenderer.Transformer {

    static var notes: BeamRenderer<Note>.Transformer {
        BeamRenderer<Note>.Transformer(beams: { $0.beams },
                                       stemDirection: { $0.stemDirection },
                                       stemEndY: { $0.stemEndY },
                                       stemLeadingEdge: { $0.stemLeadingEdge },
                                       stemTrailingEdge: { $0.stemTrailingEdge })
    }
}
