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
    @MirrorUI var startingHealth = 4.6
    @MirrorUI(range: 0...20) var damage = 5.3
    @MirrorUI var level = Level.low
    @MirrorUI var bgColor = Color.red
    #if os(macOS)
    @MirrorUI var startPoint = NSPoint(x: 3, y: 5)
    @MirrorUI var bulletSize = NSSize(width: 2, height: 6)
    #endif

    init() {
    }
}

struct MirrorControlsView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        MirrorView(object: settings)
    }
}

