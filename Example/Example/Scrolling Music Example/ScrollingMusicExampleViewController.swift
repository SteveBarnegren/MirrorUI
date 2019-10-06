//
//  ScrollingMusicExampleViewController.swift
//  Example
//
//  Created by Steve Barnegren on 21/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import UIKit
import MusicNotationKit

class ScrollingMusicExampleViewController: UIViewController {
    
    var musicViewController: ScrollingMusicViewController!
    var controlPanel: ControlPanelView!
    
    init() {
        super.init(nibName: "ScrollingMusicExampleViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        musicViewController = ScrollingMusicViewController(composition: ExampleCompositions.test)
        addChild(musicViewController)
        view.addSubview(musicViewController.view)
        
        addControlPanel()
    }
    
    private func addControlPanel() {
        
        let testSlider = SliderControl(name: "Stave spacing",
                                       getValue: { self.musicViewController.staveSpacing },
                                       setValue: { self.musicViewController.staveSpacing = $0 },
                                       minValue: 1,
                                       maxValue: 16)
        
        controlPanel = ControlPanelView(controls: [testSlider])
        controlPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlPanel)
        view.addConstraints([
            controlPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        musicViewController.view.frame = view.bounds
    }

}
