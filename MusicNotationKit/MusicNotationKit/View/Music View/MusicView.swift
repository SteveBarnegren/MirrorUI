//
//  MusicView.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import UIKit

public class MusicView: UIView {

    private var musicRenderer: MusicRenderer
    
    public var _showConstraintsDebug = false {
        didSet {
            musicRenderer._generateConstraintsDebugInformation = _showConstraintsDebug
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Init
    
    public init(composition: Composition) {
        self.musicRenderer = MusicRenderer(composition: composition)
        self.musicRenderer.preprocessComposition()
        super.init(frame: .zero)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    
    override public func draw(_ rect: CGRect) {
        
        let pathBundle = musicRenderer.paths(forDisplayWidth: Double(bounds.width))
        
        let drawer = PathBundleDrawer(size: bounds.size)
        drawer.draw(pathBundle: pathBundle)
        
        // Debug
        if _showConstraintsDebug, let debugInformation = musicRenderer._constraintsDebugInformation {
            ConstraintsDebugDrawer().draw(debugInformation: debugInformation, canvasSize: bounds.size)
        }
    }
}
