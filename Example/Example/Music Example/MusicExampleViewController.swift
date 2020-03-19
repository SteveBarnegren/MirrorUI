//
//  MusicExampleViewController.swift
//  Example
//
//  Created by Steve Barnegren on 21/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import UIKit
import MusicNotationKit

class MusicExampleViewController: UIViewController {
    
    private var musicView: MusicView!
    private var gridOverlayView: GridOverlayView!
    private var handleView = UIView(frame: .zero)
    private var musicViewWidth = CGFloat(0)
    private var panTranslation = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicViewWidth = UIScreen.main.bounds.width - 100
        
        musicView = MusicView(composition: makeComposition())
        view.addSubview(musicView)
        
        gridOverlayView = GridOverlayView(frame: .zero)
        view.addSubview(gridOverlayView)
        gridOverlayView.isHidden = true
        
        handleView.backgroundColor = UIColor.red
        view.addSubview(handleView)
        
        [musicView, gridOverlayView].forEach { $0?.isUserInteractionEnabled = false }
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(recognizer:)))
        handleView.addGestureRecognizer(panRecognizer)
    }
    
    func makeComposition() -> Composition {
        
        let composition = Composition()
        
        composition.add(bar: makeFirstBar())
        composition.add(bar: makeSecondBar())
        
        return composition
    }
    
    func makeFirstBar() -> Bar {
        let sequenceOne = NoteSequence()
        
        sequenceOne.add(note: Note(value: NoteValue(division: 8), pitch: .c4).natural())
        sequenceOne.add(note: Note(value: NoteValue(division: 8), pitch: .g4))
        sequenceOne.add(note: Note(value: NoteValue(division: 8), pitch: .e4))
        
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .g4))
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .c4))
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .a4).flat())
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .g4))
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .c4))
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .a4))
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .g4))
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .c4))
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .a4))
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .g4))
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .c4))
        sequenceOne.add(note: Note(value: NoteValue(division: 32), pitch: .a4))
        
        //        sequenceOne.add(note: Note(value: NoteValue(division: 16), pitch: .a4))
        //        sequenceOne.add(note: Note(value: NoteValue(division: 16), pitch: .e4))
        //        sequenceOne.add(note: Note(value: NoteValue(division: 16), pitch: .c4))
        //        sequenceOne.add(note: Note(value: NoteValue(division: 16), pitch: .e4))
        
        let bar = Bar()
        bar.add(sequence: sequenceOne)
        bar.timeSignature = .sixEight
        
        return bar
    }
    
    //    func makeSecondBar() -> Bar {
    //
    //        let sequence = NoteSequence()
    //
    //        sequence.add(note: Note(value: .eighth, pitch: .f3))
    //        sequence.add(note: Note(value: .eighth, pitch: .c4))
    //
    //        sequence.add(note: Note(value: .dottedQuaver, pitch: .e4))
    //        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
    //
    //        sequence.add(note: Note(value: .eighth, pitch: .a4))
    //        sequence.add(note: Note(value: .sixteenth, pitch: .g3))
    //        sequence.add(note: Note(value: .sixteenth, pitch: .f3))
    //
    //        sequence.add(note: Note(value: .sixteenth, pitch: .f3))
    //        sequence.add(note: Note(value: .eighth, pitch: .g3))
    //        sequence.add(note: Note(value: .sixteenth, pitch: .a4))
    //
    //
    //        let bar = Bar()
    //        bar.add(sequence: sequence)
    //
    //        return bar
    //    }
    
    func makeSecondBar() -> Bar {
        
        let sequence = NoteSequence()
        
        sequence.add(note: Note(value: .eighth, pitch: .c4).crossHead())
        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        
        sequence.add(note: Note(value: .dottedQuaver, pitch: .e4))
        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        
        sequence.add(note: Note(value: .eighth, pitch: .a4))
        sequence.add(note: Note(value: .sixteenth, pitch: .g3))
        sequence.add(note: Note(value: .sixteenth, pitch: .f3))
        
        sequence.add(note: Note(value: .sixteenth, pitch: .f3))
        sequence.add(note: Note(value: .eighth, pitch: .g3))
        sequence.add(note: Note(value: .sixteenth, pitch: .a4).sharp())
        
        let bar = Bar()
        bar.timeSignature = .fourFour
        bar.add(sequence: sequence)
        
        return bar
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        musicView.frame = CGRect(x: 50,
                                 y: 0,
                                 width: musicViewWidth + panTranslation,
                                 height: view.bounds.height)
        musicView.clipsToBounds = false
        musicView.layer.masksToBounds = false
        
        gridOverlayView.frame = musicView.frame
        
        layoutHandleView()
    }
    
    private func layoutHandleView() {
        
        let y = CGFloat(20)
        let size = CGFloat(30)
        let x = musicView.frame.maxX - size/2
        
        handleView.frame = CGRect(x: x, y: y, width: size, height: size)
    }
    
    // MARK: - Panning
    
    @objc func didPan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: view).x
        panTranslation = translation
        
        if recognizer.state == .ended {
            panTranslation = 0
            musicViewWidth += translation
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        musicView.setNeedsDisplay()
    }
}
