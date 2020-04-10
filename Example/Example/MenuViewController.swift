//
//  MenuViewController.swift
//  Example
//
//  Created by Steve Barnegren on 21/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import UIKit

var deeplink: DeepLink? = .component(.adjacentNoteChords)

class MenuViewController: UIViewController {
    
    init() {
        super.init(nibName: "MenuViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let dl = deeplink {
            handle(deepLink: dl)
            deeplink = nil
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func musicExampleButtonPressed(sender: UIButton) {
        
        let vc = MusicExampleViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func scrollingMusicExampleButtonPressed(sender: UIButton) {
        
        let vc = ScrollingMusicExampleViewController(composition: ExampleCompositions.test)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func componentsButtonPressed(sender: UIButton) {
        navigateToComponents(deepLink: nil)
    }
    
    // MARK: - Deeplinking
    
    private func handle(deepLink: DeepLink) {
        
        switch deepLink {
        case .component(let component):
            navigateToComponents(deepLink: component)
        }
    }
    
    // MARK: - Navigation
    
    private func navigateToComponents(deepLink: ComponentDeepLink?) {
        let vc = ComponentsMenuViewController(deepLink: deepLink)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
