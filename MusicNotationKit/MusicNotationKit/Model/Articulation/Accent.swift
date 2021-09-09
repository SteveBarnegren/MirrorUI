import Foundation

class Accent: ArticulationMark {
    // ArticulationMark
    var priorty: ArticulationMarkPriority { .accent }
    var orientation: ArticulationMarkOrientation { .byNoteHead }
    var stavePosition = StavePosition.zero
}
