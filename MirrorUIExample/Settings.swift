import Foundation
import MirrorUI
import SwiftUI

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

    init() {
    }
}

struct MirrorControlsView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        MirrorView(object: settings)
    }
}

