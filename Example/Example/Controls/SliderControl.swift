//
//  SliderControl.swift
//  Example
//
//  Created by Steve Barnegren on 06/10/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation
import UIKit

struct SliderControl: Control {
    var viewType: ControlView.Type { return SliderControlView.self }
    
    let name: String
    let getValue: () -> Double
    let setValue: (Double) -> Void
    let minValue: Double
    let maxValue: Double
}

class SliderControlView: ControlView {
    
    private var nameLabel = UILabel(frame: .zero)
    private var slider = UISlider(frame: .zero)
    private var readoutLabel = UILabel(frame: .zero)
    
    private let getValue: () -> Double
    private let setValue: (Double) -> Void
    
    private let horizontalSeparation = CGFloat(8.0)
        
    // MARK: - Init
    
    required init(model: Any) {
        guard let model = model as? SliderControl else {
            fatalError("Can only be created with SliderControl model")
        }
        
        self.getValue = model.getValue
        self.setValue = model.setValue
        
        super.init(model: model)
        
        // Name label
        self.nameLabel.text = model.name
        addSubview(self.nameLabel)
        
        // Slider
        slider.minimumValue = Float(model.minValue)
        slider.maximumValue = Float(model.maxValue)
        slider.isContinuous = true
        slider.value = Float(self.getValue())
        addSubview(self.slider)
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        // Readout
        readoutLabel.text = "0.0"
        addSubview(self.readoutLabel)
        updateReadout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getNameWidth() -> CGFloat {
        nameLabel.sizeToFit()
        return nameLabel.bounds.width
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        let views = [nameLabel, slider]
        size.height = views.map { $0.intrinsicContentSize.height }.max() ?? 0
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let placer = HorizontalViewPlacer(layoutSize: bounds.size)
        placer.place(view: nameLabel, placement: .fromStart(width: .constant(nameWidth)))
        placer.place(view: readoutLabel, placement: .fromEnd(width: .equalTo(nameLabel)))
        placer.place(view: slider, placement: .between(view1: nameLabel, view2: readoutLabel))
    }
    
    @objc private func valueChanged() {
        setValue(Double(slider.value))
        updateReadout()
    }
    
    private func updateReadout() {
        let value = getValue()
        readoutLabel.text = "\(value)"
    }
}

class HorizontalViewPlacer {
    
    enum Placement {
        case fromStart(width: WidthConstraint)
        case after(view: UIView, width: WidthConstraint)
        case fromEnd(width: WidthConstraint)
        case between(view1: UIView, view2: UIView)
    }
    
    enum WidthConstraint {
        case constant(CGFloat)
        case sizeToFit
        case equalTo(UIView)
    }
    
    private var xPos = CGFloat(0)
    private let layoutSize: CGSize
    private let separation: CGFloat
    
    init(layoutSize: CGSize, separation: CGFloat = 8.0) {
        self.layoutSize = layoutSize
        self.separation = separation
    }
    
    func place(view: UIView, placement: Placement) {
        
        let width: CGFloat
        let xPos: CGFloat
        
        func calculateWidth(forConstraint constraint: WidthConstraint) -> CGFloat {
            switch constraint {
            case .constant(let v):
                return v
            case .sizeToFit:
                view.sizeToFit()
                return view.bounds.width
            case .equalTo(let otherView):
                return otherView.bounds.width
            }
        }
        
        switch placement {
        case .fromStart(let constraint):
            xPos = 0
            width = calculateWidth(forConstraint: constraint)
        case .after(let otherView, let constraint):
            xPos = otherView.bounds.maxX + separation
            width = calculateWidth(forConstraint: constraint)
        case .fromEnd(let constraint):
            width = calculateWidth(forConstraint: constraint)
            xPos = layoutSize.width - width - separation
        case .between(let view1, let view2):
            xPos = view1.frame.maxX + separation
            width = view2.frame.minX - separation - xPos
        }
    
        view.frame = CGRect(x: xPos,
                            y: 0,
                            width: width,
                            height: layoutSize.height)
    }
}
