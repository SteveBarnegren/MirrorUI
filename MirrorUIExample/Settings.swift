import Foundation
import MirrorUI
import SwiftUI
import CoreGraphics

enum Level: CaseIterable {
    case low
    case medium
    case high
}

class Settings {

    @MirrorUI var blurEnabled = false
    @MirrorUI var lives = 4
    @MirrorUI var startingHealth = CGFloat(4.6)
    @MirrorUI(range: 0...20) var damage = 5.3
    @MirrorUI var level = Level.low
    @MirrorUI var bgColor = Color.red
    @MirrorUI var startPoint = CGPoint(x: 3, y: 5)
    @MirrorUI var endPoint = CGPoint(x: 3, y: 5)
    @MirrorUI var size = CGSize(width: 2, height: 6)
    @MirrorUI var box = CGRect(x: 0, y: 1, width: 2, height: 3)

    init() {
    }
}

struct MirrorControlsView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        MirrorView(object: settings)
    }
}

