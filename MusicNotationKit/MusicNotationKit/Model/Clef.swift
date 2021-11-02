import Foundation

public struct Clef {
    
    enum ClefType {
        case gClef // treble
        case fClef // bass
        case percussion
    }
    
    var clefType: ClefType
    
    /// The pitch of the middle line of the stave
    let middleNote: Pitch.Note
}

public extension Clef {
    static let treble = Clef(clefType: .gClef, middleNote: .b4)
    static let bass = Clef(clefType: .fClef, middleNote: .d2)
    static let percussion = Clef(clefType: .percussion, middleNote: .b4) // middle note same as treble
}
