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
    
    let settings = Settings()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func showSettingsButtonPressed() {
        let mirrorView = MirrorView(object: settings)
        let viewController = UIHostingController(rootView: mirrorView)
        present(viewController, animated: true, completion: nil)
    }


}

