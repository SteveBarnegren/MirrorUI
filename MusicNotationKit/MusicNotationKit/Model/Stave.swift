import Foundation

public enum StaveStyle {
    case fiveLine
    case singleLine
}

public class Stave {

    public var style = StaveStyle.fiveLine
    public var clef = Clef.treble
    var bars = [Bar]()
    
    var duration: Time {
        return bars.reduce(Time.zero) { $0 + $1.duration }
    }

    var requiredStemDirection: StemDirection? {
        switch self.style {
            case .fiveLine:
                return nil
            case .singleLine:
                return .up
        }
    }
    
    public init() {}
    
    public func add(bar: Bar) {
        self.bars.append(bar)
    }
    
    func forEachNote(_ handler: (Note) -> Void) {
        
        for bar in bars {
            for noteSequence in bar.sequences {
                for note in noteSequence.notes {
                    handler(note)
                }
            }
        }
        
    }
}
