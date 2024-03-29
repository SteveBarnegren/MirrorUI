import Foundation
import MirrorUI
import SwiftUI
import CoreGraphics

enum Level: CaseIterable {
    case low
    case medium
    case high
}

enum Size: Int {
    case small
    case medium
    case large
}

class Settings {

    @MirrorUI var blurEnabled = false
    @MirrorUI var lives = 4
    @MirrorUI var startingHealth = CGFloat(4.6)
    @MirrorUI(range: 0...20) var damage = 5.3
    @MirrorUI var level = Level.low
    #if os(iOS) || os(macOS)
    @MirrorUI var bgColor = Color.red
    #endif
    @MirrorUI var startPoint = CGPoint(x: 3, y: 5)
    @MirrorUI var endPoint = CGPoint(x: 3, y: 5)
    @MirrorUI var box = CGRect(x: 0, y: 1, width: 2, height: 3)
    @MirrorUI var size = Size.medium
    @MirrorUI var greeting = "Hello"
}

func makeCustomSizeViewMapping() -> ViewMapping {
    return ViewMapping(for: Size.self) { (ref, context) -> AnyView in

        let binding = Binding(get: { ref.value.rawValue },
                              set: { ref.value = Size(rawValue: $0)! })

        let view = VStack(alignment: .leading, spacing: 0) {
            #if os(iOS)
            Text(context.propertyName)
            #endif
            Picker(context.propertyName, selection: binding) {
                Text("Small").tag(0)
                Text("Medium").tag(1)
                Text("Large").tag(2)
            }
        }

        return AnyView(view)
    }
}

struct MirrorControlsView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        let mapper = ViewMapper.mapperWithDefaultMappings()
        mapper.add(mapping: makeCustomSizeViewMapping())
        return MirrorView(object: settings, viewMapper: mapper)
    }
}

