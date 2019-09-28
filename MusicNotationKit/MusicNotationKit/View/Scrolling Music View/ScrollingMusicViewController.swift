//
//  ScrollingMusicViewController.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import UIKit

public class ScrollingMusicViewController: UIViewController, UICollectionViewDataSource {
   
    private let renderer: MusicRenderer
    private var collectionView: UICollectionView!
    private var collectionViewLayout: MusicCollectionViewLayout!
    private var compositionLayout = CompositionLayout(barWidths: [], layoutWidth: 0)
    
    // MARK: - Init
    
    public init(composition: Composition) {
        self.renderer = MusicRenderer(composition: composition)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Load
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewLayout = MusicCollectionViewLayout()
        self.collectionViewLayout.dataSource = self
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        view.addSubview(self.collectionView)
        
        collectionView.register(MusicCell.self, forCellWithReuseIdentifier: "MusicCell")
        
        view.backgroundColor = .white
        processComposition()
    }
    
    private func processComposition() {
        print("Process composition")
        self.renderer.preprocessComposition()
    }
    
    // MARK: - Layout
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds.inset(by: view.safeAreaInsets)
        
        print("Work out bar layout")
        let barWidths = self.renderer.minimumBarWidths()
        compositionLayout = CompositionLayout(barWidths: barWidths, layoutWidth: Double(collectionView.bounds.width))
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numItems = compositionLayout.compositionItems.count
        print("Number of items: \(numItems)")
        return numItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCell", for: indexPath) as! MusicCell
        let item = compositionLayout.compositionItems[indexPath.row]

        let paths = renderer.paths(forDisplaySize: item.size, range: item.barRange)
        cell.configure(withPaths: paths)
        
        return cell
    }
    
}

// MARK: - MusicCollectionViewLayoutDataSource

extension ScrollingMusicViewController: MusicCollectionViewLayoutDataSource {
    
    func compositionLayout(forMusicCollectionViewLayout layout: MusicCollectionViewLayout) -> CompositionLayout {
        return self.compositionLayout
    }
}
