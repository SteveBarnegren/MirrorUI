//
//  ControlsView.swift
//  Example
//
//  Created by Steve Barnegren on 06/10/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import UIKit

// MARK: - Control

protocol Control {
    var viewType: ControlView.Type { get }
}

extension Control {
    func makeView() -> ControlView {
        return self.viewType.init(model: self)
    }
}

// MARK: - Control View

class ControlView: UIView {
    
    var nameWidth = CGFloat(0)
    
    func getNameWidth() -> CGFloat {
        return 0
    }
    
    required init(model: Any) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Panel

class ControlPanelView: UIView {
        
    private var controls = [Control]()
    private var controlViews = [ControlView]()
    private let separation = CGFloat(8)
    
    init(controls: [Control]) {
        self.controls = controls
        super.init(frame: .zero)
        makeViews()
        self.backgroundColor = .magenta
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeViews() {
        
        for control in controls {
            let view = control.makeView()
            addSubview(view)
            controlViews.append(view)
        }
    }
    
    override func layoutSubviews() {
        
        let nameWidth = controlViews.map { $0.getNameWidth() }.max() ?? 0
        controlViews.forEach { $0.nameWidth = nameWidth }
        
        var yPos = CGFloat(0)
        
        for controlView in controlViews {
            
            let height = controlView.intrinsicContentSize.height
            controlView.frame = CGRect(x: 0,
                                       y: yPos,
                                       width: bounds.width,
                                       height: height)
            yPos += height
            yPos += separation
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        let controlsHeight = controlViews.map { $0.intrinsicContentSize.height }.reduce(0, +)
        let separationHeight = max(0, CGFloat(controlViews.count - 1) * separation)
        size.height = controlsHeight + separationHeight
        return size
    }
}
