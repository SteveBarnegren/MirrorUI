//
//  MusicCollectionViewLayout.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import UIKit

protocol MusicCollectionViewLayoutDataSource: class {
    func compositionLayout(forMusicCollectionViewLayout layout: MusicCollectionViewLayout) -> CompositionLayout
}

class MusicCollectionViewLayout: UICollectionViewLayout {
    
    weak var dataSource: MusicCollectionViewLayoutDataSource!
    
    private var calculatedCellRects = [CGRect]()
    
    override var collectionViewContentSize: CGSize {
        let width = collectionView!.frame.size.width
        let height = calculatedCellRects.last?.maxY ?? 0
        return CGSize(width: width, height: height)
    }
    
    override func prepare() {
        super.prepare()
        
        let layout = dataSource.compositionLayout(forMusicCollectionViewLayout: self)
        
        var cellRects = [CGRect]()
        
        var yPos = CGFloat(0)
        for item in layout.compositionItems {
            
            let cellHeight = CGFloat(item.size.height)
            let cellRect = CGRect(x: CGFloat(0), y: yPos, width: collectionView!.bounds.width, height: cellHeight)
            cellRects.append(cellRect)
            yPos += cellHeight
        }
        
        self.calculatedCellRects = cellRects
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesArray = [UICollectionViewLayoutAttributes]()
        
        for (index, cellRect) in calculatedCellRects.enumerated() where cellRect.intersects(rect) {
            let indexPath = IndexPath(item: index, section: 0)
            if let attributes = layoutAttributesForItem(at: indexPath) {
                attributesArray.append(attributes)
            }
        }
        
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let cellRect = calculatedCellRects[indexPath.item]
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = cellRect
        return attributes
    }
    
    func updateCellHeights(fromIndex index: Int) {
                        
        let layout = dataSource.compositionLayout(forMusicCollectionViewLayout: self)
        print("Layout heights: \(layout.compositionItems.map { $0.size.height })")
        
        var yPos = calculatedCellRects[maybe: index-1]?.maxY ?? 0
        
        for i in index..<calculatedCellRects.count {
            let compositionItem = layout.compositionItems[i]
            let cellHeight = CGFloat(compositionItem.size.height)
            let cellRect = CGRect(x: CGFloat(0), y: yPos, width: collectionView!.bounds.width, height: cellHeight)
            calculatedCellRects[i] = cellRect
            yPos += cellHeight
        }
        
        let context = UICollectionViewLayoutInvalidationContext()
        let indexPathsToInvalidate = (index..<calculatedCellRects.count).map { IndexPath(item: $0, section: 0) }
        context.invalidateItems(at: indexPathsToInvalidate)
        invalidateLayout(with: context)
    }
}
