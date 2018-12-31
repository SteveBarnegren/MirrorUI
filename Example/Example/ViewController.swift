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

    override func viewDidLoad() {
        super.viewDidLoad()
        musicView = MusicView(composition: makeComposition())
        view.addSubview(musicView)
        
        gridOverlayView = GridOverlayView(frame: .zero)
        view.addSubview(gridOverlayView)
    }
    
    func makeComposition() -> Composition {
        
        let composition = Composition()
        // bar 0
        composition.add(note: Note(value: .eighth, pitch: .c4), toBar: 0)
        composition.add(note: Note(value: .eighth, pitch: .c4), toBar: 0)
        composition.add(note: Note(value: .quarter, pitch: .c4), toBar: 0)
        composition.add(note: Note(value: .sixteenth, pitch: .c4), toBar: 0)
        composition.add(note: Note(value: .sixteenth, pitch: .c4), toBar: 0)
        composition.add(note: Note(value: .eighth, pitch: .c4), toBar: 0)
        composition.add(note: Note(value: .eighth, pitch: .c4), toBar: 0)
        composition.add(note: Note(value: .eighth, pitch: .c4), toBar: 0)
        
        // bar 1
        composition.add(note: Note(value: .sixteenth, pitch: .c4), toBar: 1)
        composition.add(note: Note(value: .sixteenth, pitch: .c4), toBar: 1)
        composition.add(note: Note(value: .sixteenth, pitch: .c4), toBar: 1)
        composition.add(note: Note(value: .sixteenth, pitch: .c4), toBar: 1)
        composition.add(note: Note(value: .sixteenth, pitch: .c4), toBar: 1)
        composition.add(note: Note(value: .eighth, pitch: .c4), toBar: 1)
        composition.add(note: Note(value: .sixteenth, pitch: .c4), toBar: 1)
        composition.add(note: Note(value: .eighth, pitch: .c4), toBar: 1)
        composition.add(note: Note(value: .sixteenth, pitch: .c4), toBar: 1)
        composition.add(note: Note(value: .sixteenth, pitch: .c4), toBar: 1)
        composition.add(note: Note(value: .quarter, pitch: .c4), toBar: 1)

        return composition
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        musicView.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
        musicView.clipsToBounds = false
        musicView.layer.masksToBounds = false
        
        gridOverlayView.frame = musicView.frame
    }
}

