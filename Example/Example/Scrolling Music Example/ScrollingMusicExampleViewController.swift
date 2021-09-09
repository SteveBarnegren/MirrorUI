import UIKit
import MusicNotationKit
import MirrorUI
import SBAutoLayout

private class ScrollingMusicSettings {
    @MirrorUI(range: 1...16) var staveSpacing = 8.0
    @MirrorUI var drawLayoutAnchors = false
}

class ScrollingMusicExampleViewController: UIViewController {
    
    private var settings = ScrollingMusicSettings()
    private var musicViewController: ScrollingMusicViewController!
    private let composition: Composition
    private var settingsViewController: MirrorViewController!
    private var settingsVisible = false
    private var showSettingsButton: UIButton!
    
    init(composition: Composition) {
        self.composition = composition
        super.init(nibName: "ScrollingMusicExampleViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        musicViewController = ScrollingMusicViewController(composition: self.composition)
        addChild(musicViewController)
        view.addSubview(musicViewController.view)
        
        configureSettings()
        addShowSettingsButton()
        addPopupSettings()
    }
    
    private func configureSettings() {
        settings.staveSpacing = self.musicViewController.staveSpacing
        settings.$staveSpacing.didSet = { [unowned self] in
            self.musicViewController.staveSpacing = $0
        }
        
        settings.$drawLayoutAnchors.didSet = { [unowned self] in
            self.musicViewController._debugConstraints = $0
        }
    }
    
    private func addPopupSettings() {
        
        let settingsVC = MirrorViewController(object: settings)
        addChild(settingsVC)
        view.addSubview(settingsVC.view)
        self.settingsViewController = settingsVC
        settingsVC.view.backgroundColor = UIColor(white: 0.98, alpha: 1)
        
        let stripView = UIView(frame: .zero)
        stripView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        settingsVC.view.addSubview(stripView)
        stripView.pinToSuperviewAsTopStrip(height: 0.5)
        
        let closeImage = UIImage(systemName: "xmark.circle.fill")
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(closeImage, for: .normal)
        closeButton.imageView?.tintColor = .gray
        settingsVC.view.addSubview(closeButton)
        closeButton.pinToSuperviewTop(8)
        closeButton.pinToSuperviewRight(8)
        closeButton.addTarget(self, action: #selector(closeSettingsPressed), for: .touchUpInside)
    }
    
    private func addShowSettingsButton() {
        let image = UIImage(systemName: "chevron.up.circle.fill")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .gray
        view.addSubview(button)
        button.pinToSuperviewRight(8)
        button.pinToSafeAreaBottom(8)
        button.addTarget(self, action: #selector(openSettingsPressed), for: .touchUpInside)
        
        self.showSettingsButton = button
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        musicViewController.view.frame = view.bounds
        
        let settingsHeight = CGFloat(150)
        
        var settingsY = view.bounds.height
        if settingsVisible {
            settingsY -= settingsHeight
        }
        
        settingsViewController.view.frame = CGRect(
            x: 0,
            y: settingsY,
            width: view.bounds.width,
            height: settingsHeight
        )
    }
    
    @objc private func openSettingsPressed() {
        showSettings(true)
    }
    
    @objc private func closeSettingsPressed() {
        showSettings(false)
    }
    
    private func showSettings(_ show: Bool) {
        if show == settingsVisible {
            return
        }
        
        settingsVisible = show
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in }
    }
}
