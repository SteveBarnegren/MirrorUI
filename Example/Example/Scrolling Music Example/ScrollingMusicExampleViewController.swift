//
//  ScrollingMusicExampleViewController.swift
//  Example
//
//  Created by Steve Barnegren on 21/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import UIKit
import MusicNotationKit
import PopupControls

class ScrollingMusicExampleViewController: UIViewController {
    
    var musicViewController: ScrollingMusicViewController!
    
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
        
        addPopupControls()
    }
    
    private func addPopupControls() {
        
        let controls = PopUpControlsViewController.overlay(onViewController: self, initialState: .collapsed)
        
        let staveSpacing = SliderItem(name: "Stave spacing",
                                      min: 1,
                                      max: 16,
                                      getValue: { Float(self.musicViewController.staveSpacing) },
                                      setValue: { self.musicViewController.staveSpacing = Double($0) })
        
        controls.show(items: [staveSpacing])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        musicViewController.view.frame = view.bounds
    }

}
