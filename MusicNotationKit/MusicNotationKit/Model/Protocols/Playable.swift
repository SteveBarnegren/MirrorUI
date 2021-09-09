import Foundation

protocol Playable: HorizontalLayoutItem {
    var value: NoteValue { get set }
    var barTime: Time { get set }
    var compositionTime: CompositionTime { get set }
}

extension Playable {
    var duration: Time {
        return value.duration
    }
}
