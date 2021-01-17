//
//  ViewController.swift
//  MirrorUIExample
//
//  Created by Steve Barnegren on 16/01/2021.
//

import UIKit
import MirrorUI
import SwiftUI

class ViewController: UIViewController {
    
    private let settings = Settings()
    private var settingsViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mirrorView = MirrorView(object: settings)
        let viewController = UIHostingController(rootView: mirrorView)
        view.addSubview(viewController.view)
        addChild(viewController)
        settingsViewController = viewController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsViewController.view.frame = view.bounds
    }


}

