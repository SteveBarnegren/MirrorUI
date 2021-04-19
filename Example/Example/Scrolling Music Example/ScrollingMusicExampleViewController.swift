//
//  ScrollingMusicExampleViewController.swift
//  Example
//
//  Created by Steve Barnegren on 21/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import UIKit
import MusicNotationKit
import MirrorUI
import SBAutoLayout

private class ScrollingMusicSettings {
    @MirrorUI(range: 1...16) var staveSpacing = 8.0
}

class ScrollingMusicExampleViewController: UIViewController {
    
    private var settings = ScrollingMusicSettings()
    private var musicViewController: ScrollingMusicViewController!
    private let composition: Composition
    private var settingsViewController: MirrorViewController!
    
    init(composition: Composition) {
        self.composition = composition
        super.init(nibName: "ScrollingMusicExampleViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        musicViewController = ScrollingMusicViewController(composition: self.composition)
        addChild(musicViewController)
        view.addSubview(musicViewController.view)
        
        configureSettings()
        addPopupSettings()
    }
    
    private func configureSettings() {
        settings.staveSpacing = self.musicViewController.staveSpacing
        settings.$staveSpacing.didSet = {
            self.musicViewController.staveSpacing = $0
        }
    }
    
    private func addPopupSettings() {
        
        let settingsVC = MirrorViewController(object: settings)
        addChild(settingsVC)
        view.addSubview(settingsVC.view)
        self.settingsViewController = settingsVC
        settingsVC.view.backgroundColor = UIColor(white: 0.98, alpha: 1)
        
        let stripView = UIView(frame: .zero)
        stripView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        settingsVC.view.addSubview(stripView)
        stripView.pinToSuperviewAsTopStrip(height: 0.5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        musicViewController.view.frame = view.bounds
        
        let settingsHeight = CGFloat(150)
        settingsViewController.view.frame = CGRect(
            x: 0,
            y: view.bounds.height - settingsHeight,
            width: view.bounds.width,
            height: settingsHeight
        )
    }

}
