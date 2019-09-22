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
        
        contentView.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        view.frame = contentView.bounds
    }
}

private class MusicCellView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.orange.set()
        let path = UIBezierPath(rect: bounds)
        path.lineWidth = 10
        path.stroke()
    }
}
