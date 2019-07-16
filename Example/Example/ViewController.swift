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
    
    @IBOutlet private var debugConstraintsStackView: UIStackView!
    @IBOutlet private var debugConstraintsSwitch: UISwitch!
    
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
        
        // Debug Constraints
        debugConstraintsStackView.superview?.bringSubviewToFront(debugConstraintsStackView)
        musicView._showConstraintsDebug = debugConstraintsEnabled
        debugConstraintsSwitch.isOn = debugConstraintsEnabled
    }
    
    func makeComposition() -> Composition {
        
        let composition = Composition()
        
        composition.add(bar: makeFirstBar())
       // composition.add(bar: makeSecondBar())
        
        composition.add(bar: makeBasicBar())

        return composition
    }
    
//    func makeBasicBar() -> Bar {
//
//        let bar = Bar()
//
//        let sequence1 = NoteSequence()
//        sequence1.add(note: Note(value: .quarter, pitch: .g4))
//        sequence1.add(note: Note(value: .sixteenth, pitch: .g4))
//        sequence1.add(note: Note(value: .sixteenth, pitch: .g4))
//        sequence1.add(note: Note(value: .sixteenth, pitch: .g4))
//        sequence1.add(note: Note(value: .sixteenth, pitch: .g4))
//        sequence1.add(note: Note(value: .eighth, pitch: .g4))
//        sequence1.add(note: Note(value: .eighth, pitch: .g4))
//        sequence1.add(note: Note(value: .quarter, pitch: .g4))
//        bar.add(sequence: sequence1)
//
//        let sequence2 = NoteSequence()
//        sequence2.add(note: Note(value: .eighth, pitch: .f3))
//        sequence2.add(note: Note(value: .eighth, pitch: .f3))
//        sequence2.add(note: Note(value: .eighth, pitch: .f3))
//        sequence2.add(note: Note(value: .eighth, pitch: .f3))
//        sequence2.add(note: Note(value: .quarter, pitch: .f3))
//        sequence2.add(note: Note(value: .sixteenth, pitch: .f3))
//        sequence2.add(note: Note(value: .sixteenth, pitch: .f3))
//        sequence2.add(note: Note(value: .sixteenth, pitch: .f3))
//        sequence2.add(note: Note(value: .sixteenth, pitch: .f3))
//        bar.add(sequence: sequence2)
//
//        return bar
//    }
    
    func makeBasicBar() -> Bar {

        let bar = Bar()

        let sequence1 = NoteSequence()
        
        sequence1.add(rest: Rest(value: .eighth))
        sequence1.add(note: Note(value: .eighth, pitch: .g4))
        //sequence1.add(note: Note(value: .dottedQuaver, pitch: .g4))
        //sequence1.add(note: Note(value: .sixteenth, pitch: .g4))
        sequence1.add(note: Note(value: .doubleDottedQuaver, pitch: .g4))
        sequence1.add(note: Note(value: .init(division: 32), pitch: .g4))
        sequence1.add(note: Note(value: .eighth, pitch: .g4))
        sequence1.add(note: Note(value: .eighth, pitch: .g4))
        bar.add(sequence: sequence1)

        let sequence2 = NoteSequence()
        sequence2.add(note: Note(value: .dottedQuaver, pitch: .f3))
        sequence2.add(note: Note(value: .sixteenth, pitch: .f3).flat())
        sequence2.add(note: Note(value: .quarter, pitch: .f3))
        sequence2.add(note: Note(value: .dottedQuaver, pitch: .f3))
        sequence2.add(note: Note(value: .sixteenth, pitch: .f3).sharp())
        sequence2.add(note: Note(value: .quarter, pitch: .f3).natural())
        bar.add(sequence: sequence2)

        return bar
    }
    
    func makeBar() -> Bar {
        let sequenceOne = NoteSequence()
        
        sequenceOne.add(note: Note(value: .sixteenth, pitch: .f3))
        sequenceOne.add(note: Note(value: .eighth, pitch: .f3))
        sequenceOne.add(note: Note(value: .sixteenth, pitch: .f3))
        
        let bar = Bar()
        bar.add(sequence: sequenceOne)
        
        return bar
    }
    
    func makeFirstBar() -> Bar {
        let sequenceOne = NoteSequence()
        
        sequenceOne.add(note: Note(value: NoteValue(division: 4), pitch: .b4))
        sequenceOne.add(rest: Rest(value: .sixteenth))
        sequenceOne.add(note: Note(value: NoteValue(division: 16), pitch: .b4))
        sequenceOne.add(rest: Rest(value: .sixteenth))
        sequenceOne.add(note: Note(value: NoteValue(division: 16), pitch: .b4))
        sequenceOne.add(note: Note(value: NoteValue(division: 8, dots: .dotted), pitch: .b4))
        sequenceOne.add(note: Note(value: .sixteenth, pitch: .a4))
        sequenceOne.add(note: Note(value: .sixteenth, pitch: .f3))
        sequenceOne.add(note: Note(value: .eighth, pitch: .f3))
        sequenceOne.add(note: Note(value: .sixteenth, pitch: .f3))

        let bar = Bar()
        bar.add(sequence: sequenceOne)
        
        return bar
    }
    
//    func makeSecondBar() -> Bar {
//        let sequenceOne = NoteSequence()
//
//        sequenceOne.add(note: Note(value: NoteValue(division: 4, dots: .dotted), pitch: .f3))
//        sequenceOne.add(note: Note(value: .eighth, pitch: .g3))
//        sequenceOne.add(note: Note(value: NoteValue(division: 8, dots: .dotted), pitch: .g4))
//        sequenceOne.add(note: Note(value: .sixteenth, pitch: .e4))
//        sequenceOne.add(note: Note(value: .quarter, pitch: .c4))
//
//        let bar = Bar()
//        bar.add(sequence: sequenceOne)
//
//        return bar
//    }

    
//    func makeFirstBar() -> Bar {
//        let sequenceOne = NoteSequence()
//
//        sequenceOne.add(note: Note(value: .quarter, pitch: .c4))
//        sequenceOne.add(note: Note(value: NoteValue(division: 4, dots: .dotted), pitch: .c4))
//        sequenceOne.add(note: Note(value: NoteValue(division: 4, dots: .doubleDotted), pitch: .c4))
//
//        sequenceOne.add(note: Note(value: .eighth, pitch: .c4))
//        sequenceOne.add(note: Note(value: .eighth, pitch: .c4))
//
//        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
//        sequenceOne.add(note: Note(value: .eighth, pitch: .c4))
//        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
//
//        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
//        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
//        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
//        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
//
//        sequenceOne.add(rest: Rest(value: .eighth))
//        sequenceOne.add(rest: Rest(value: .sixteenth))
//        sequenceOne.add(rest: Rest(value: .half))
//        sequenceOne.add(rest: Rest(value: .whole))
//
//        sequenceOne.add(note: Note(value: .sixteenth, pitch: .c4))
//
//        let bar = Bar()
//        bar.add(sequence: sequenceOne)
//
//        return bar
//    }
    
    func makeSecondBar() -> Bar {

        let sequence = NoteSequence()

        sequence.add(note: Note(value: .eighth, pitch: .c4))
        sequence.add(note: Note(value: .eighth, pitch: .c4))

        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        sequence.add(note: Note(value: .sixteenth, pitch: .c4))
        sequence.add(note: Note(value: .eighth, pitch: .c4))

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
    
//    func makeSecondBar() -> Bar {
//
//        let sequence = NoteSequence()
//
//        sequence.add(rest: Rest(value: .quarter))
//        sequence.add(rest: Rest(value: .quarter))
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
    
    // MARK: - Debug Constraints
    
    var debugConstraintsEnabled: Bool {
        get { return UserDefaults.standard.bool(forKey: "debug_constraints") }
        set { UserDefaults.standard.set(newValue, forKey: "debug_constraints") }
    }
    
    @IBAction private func debugConstraintsSwitchChanges(sender: UISwitch) {
        debugConstraintsEnabled = debugConstraintsSwitch.isOn
        musicView._showConstraintsDebug = debugConstraintsEnabled
    }
}

