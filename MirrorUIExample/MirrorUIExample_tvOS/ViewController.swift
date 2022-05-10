import UIKit
import MirrorUI
import SwiftUI

class ViewController: UIViewController {

    private let settings = Settings()
    private var settingsViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        ViewMapper.shared.add(mapping: makeCustomSizeViewMapping())

        let mirrorView = MirrorView(object: settings)
        let viewController = UIHostingController(rootView: mirrorView)
        view.addSubview(viewController.view)
        addChild(viewController)
        settingsViewController = viewController
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsViewController.view.frame = view.bounds
    }
}
