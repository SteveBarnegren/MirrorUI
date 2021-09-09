import Foundation

extension ConflictIdentifiers {
    
    static var tiesAndArticulationMarks: ConflictIdentifier<Tie, ArticulationMark> {
        return ConflictIdentifier<Tie, ArticulationMark>(areCompatible: isTieAndArticulationCompatible)
    }
    
    static func isTieAndArticulationCompatible(tie: Tie, articulationMark: ArticulationMark) -> Bool {

        let startNote = tie.fromNote!
        let endNote = tie.toNote!

        if tie.orientation == .verticallyAlignedWithNote
            && (startNote.articulationMarks.contains(where: { $0 === articulationMark }) || endNote.articulationMarks.contains(where:{ $0 === articulationMark })) {
            return false
        }
        
        return true
    }
}
