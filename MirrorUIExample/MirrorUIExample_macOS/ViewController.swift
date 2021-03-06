//
//  ViewController.swift
//  MirrorUIExample_macOS
//
//  Created by Steve Barnegren on 16/01/2021.
//

import Cocoa
import MirrorUI
import SwiftUI

class ViewController: NSViewController {

    private let settings = Settings()
    private var mirrorHostingView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ViewMapper.shared.add(mapping: makeCustomSizeViewMapping())
        let mirrorView = MirrorView(object: settings)
        mirrorHostingView = NSHostingView(rootView: mirrorView)
        view.addSubview(mirrorHostingView)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        mirrorHostingView.frame = view.bounds
    }
}
