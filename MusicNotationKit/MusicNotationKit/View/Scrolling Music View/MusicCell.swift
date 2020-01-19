//
//  MusicCell.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 22/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import UIKit

class MusicCell: UICollectionViewCell {
    
    private let view = MusicCellView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        contentView.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        // Use ceil of content view height to avoid occasional rounding error where subview
        // is not rendered as fully covering content view
        var viewFrame = contentView.bounds
        viewFrame.size.height = ceil(viewFrame.height)
        view.frame = viewFrame
    }
    
    func configure(withPaths paths: [Path]) {
        view.configure(withPaths: paths)
    }
}

private class MusicCellView: UIView {
    
    private var paths = [Path]()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withPaths paths: [Path]) {
        self.paths = paths
        self.setNeedsDisplay()
        
        //self.layer.borderColor = UIColor.yellow.cgColor
        //self.layer.borderWidth = 0.5
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let pathDrawer = PathDrawer(size: bounds.size)
        pathDrawer.draw(paths: paths)
    }
}
