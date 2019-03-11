//
//  ViewController.swift
//  Example
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import UIKit
import MusicNotationKit

class ViewController: UIViewController {
    
    var musicView: MusicView!
    var gridOverlayView: GridOverlayView!
    var handleView = UIView(frame: .zero)
    var musicViewWidth = CGFloat(0)
    var panTranslation = CGFloat(0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicViewWidth = UIScreen.main.bounds.width - 100
        
        musicView = MusicView(composition: makeComposition())
        musicView._showConstraintsDebug = true
        view.addSubview(musicView)
        
        gridOverlayView = GridOverlayView(frame: .zero)
        view.addSubview(gridOverlayView)
        
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

        sequenceOne.add(note: Note(value: .quarter, pitch: .c4))

        sequenceOne.add(note: Note(value: .eighth, pitch: .c4))
        sequenceOne.add(note: Note(value: .eighth, pitch: .c4))

        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
        sequenceOne.add(note: Note(value: .eighth, pitch: .c4))
        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))

        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))

        let bar = Bar()
        bar.add(sequence: sequenceOne)

        return bar
    }
    
//    func makeSecondBar() -> Bar {
//
//        let sequence = NoteSequence()
//
//        sequence.add(note: Note(value: .eighth, pitch: .c4))
//        sequence.add(note: Note(value: .eighth, pitch: .c4))
//
//        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
//        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
//        sequence.add(note: Note(value: .eighth, pitch: .c4))
//
//        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
//        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
//        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
//        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
//
//        sequence.add(note: Note(value: .eighth, pitch: .c4))
//        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
//        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
//
//        let bar = Bar()
//        bar.add(sequence: sequence)
//
//        return bar
//    }
    
    func makeSecondBar() -> Bar {
        
        let sequence = NoteSequence()
        
        sequence.add(rest: Rest(value: .half))
        
        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        
        sequence.add(note: Note(value: .eighth, pitch: .c4))
        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        
        let bar = Bar()
        bar.add(sequence: sequence)
        
        return bar
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("Layout subviews")
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
        
        print("TRANS: \(translation)")
    }
}

