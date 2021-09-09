import UIKit

public class MusicView: UIView {

    private var musicRenderer: MusicRenderer
    
    // MARK: - Init
    
    public init(composition: Composition) {
        self.musicRenderer = MusicRenderer(composition: composition)
        self.musicRenderer.preprocessComposition()
        super.init(frame: .zero)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    
    override public func draw(_ rect: CGRect) {
        
        let pathBundle = musicRenderer.pathBundle(forDisplayWidth: Double(bounds.width))
        
        let drawer = PathBundleDrawer(size: bounds.size)
        drawer.draw(pathBundle: pathBundle)
    }
}
