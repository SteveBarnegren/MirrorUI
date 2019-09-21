//
//  MenuViewController.swift
//  Example
//
//  Created by Steve Barnegren on 21/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    init() {
        super.init(nibName: "MenuViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction private func musicExampleButtonPressed(sender: UIButton) {
        
        let vc = MusicExampleViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func scrollingMusicExampleButtonPressed(sender: UIButton) {
        
        let vc = ScrollingMusicExampleViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
