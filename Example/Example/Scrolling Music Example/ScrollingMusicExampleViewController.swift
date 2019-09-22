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
    
    init() {
        super.init(nibName: "ScrollingMusicExampleViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        musicViewController = ScrollingMusicViewController(composition: ExampleCompositions.randomComposition)
        addChild(musicViewController)
        view.addSubview(musicViewController.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        musicViewController.view.frame = view.bounds
    }

}
