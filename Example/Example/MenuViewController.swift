import UIKit

class MenuViewController: UIViewController {
    
    var deeplink: Deeplink?
    
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
        handleDeeplink()
    }
    
    // MARK: - Deeplink
    
    private func handleDeeplink() {
        
        guard let path = deeplink?.nextPathComponent() else {
            return
        }
        
        switch path {
        case "components":
            navigateToComponents(deeplink: deeplink)
        default:
            print("Unknown deeplink path: \(path)")
        }
        
        deeplink = nil
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
        navigateToComponents()
    }
    
    // MARK: - Navigation
    
    private func navigateToComponents(deeplink: Deeplink? = nil) {
        let vc = ComponentsMenuViewController()
        vc.deeplink = deeplink
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
