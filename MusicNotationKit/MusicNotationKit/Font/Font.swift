import Foundation
import UIKit

class Font {
    
    let name: String
    let uiFont: UIFont
    let metadata: [String: Any]
    var metrics = FontMetrics()
    
    init(name: String, metadata: [String: Any]) {
        self.name = name
        self.uiFont = UIFont(name: name, size: 4)!
        self.metadata = metadata
        
        let assertAllValues = (name == "Bravura")
        if let metricsDict = metadata["engravingDefaults"] as? [String: Any] {
            metrics.configure(dictionary: metricsDict, assertAllValuesPresent: assertAllValues)
        } else if assertAllValues {
            assertionFailure("Unable to find metrics dict")
        }
    }
}

struct FontMetrics {
    
    // *** SMuFL values. Uses Bravura values as default ***

    // The thickness of the line used for the shaft of an arrow
    var arrowShaftThickness: Double = 0.16
    // The default distance between multiple thin barlines when locked together, e.g. between two thin barlines making a double barline, measured from the right-hand edge of the left barline to the left-hand edge of the right barline.
    var barlineSeparation: Double = 0.4
    // The distance between the inner edge of the primary and outer edge of subsequent secondary beams
    var beamSpacing: Double = 0.25
    // The thickness of a beam
    var beamThickness: Double =  0.5
    // The thickness of the vertical line of a bracket grouping staves together
    var bracketThickness: Double =  0.5
    // The length of the dashes to be used in a dashed barline
    var dashedBarlineDashLength: Double =  0.5
    // The length of the gap between dashes in a dashed barline
    var dashedBarlineGapLength: Double = 0.25
    // The thickness of a dashed barline
    var dashedBarlineThickness: Double = 0.16
    // The thickness of a crescendo/diminuendo hairpin
    var hairpinThickness: Double = 0.16
    // The amount by which a leger line should extend either side of a notehead, scaled proportionally with the notehead's size, e.g. when scaled down as a grace note
    var legerLineExtension: Double =  0.4
    // The thickness of a leger line (normally somewhat thicker than a staff line)
    var legerLineThickness: Double = 0.16
    // The thickness of the lyric extension line to indicate a melisma in vocal music
    var lyricLineThickness: Double = 0.16
    // The thickness of the dashed line used for an octave line
    var octaveLineThickness: Double = 0.16
    // The thickness of the line used for piano pedaling
    var pedalLineThickness: Double = 0.16
    // The default horizontal distance between the dots and the inner barline of a repeat barline, measured from the edge of the dots to the edge of the barline.
    var repeatBarlineDotSeparation: Double = 0.16
    // The thickness of the brackets drawn to indicate repeat endings
    var repeatEndingLineThickness: Double = 0.16
    // The thickness of the end of a slur
    var slurEndpointThickness: Double =  0.1
    // The thickness of the mid-point of a slur (i.e. its thickest point)
    var slurMidpointThickness: Double = 0.22
    // The thickness of each staff line
    var staffLineThickness: Double = 0.13
    // The thickness of a stem
    var stemThickness: Double = 0.12
    // The thickness of the vertical line of a sub-bracket grouping staves belonging to the same instrument together
    var subBracketThickness: Double = 0.16
    // The thickness of a box drawn around text instructions (e.g. rehearsal marks)
    var textEnclosureThickness: Double = 0.16
    // The thickness of a thick barline, e.g. in a final barline or a repeat barline
    var thickBarlineThickness: Double =  0.5
    // The thickness of a thin barline, e.g. a normal barline, or each of the lines of a double barline
    var thinBarlineThickness: Double = 0.16
    // The thickness of the end of a tie
    var tieEndpointThickness: Double =  0.1
    // The thickness of the mid-point of a tie
    var tieMidpointThickness: Double = 0.22
    // The thickness of the brackets drawn either side of tuplet numbers
    var tupletBracketThickness: Double =  0.1

    // *** Additional values (not in the SMuFL spec) ***
    var graceNoteScale: Double = 0.5

    // *** Computed values ***
    var graceNoteStemThickness: Double {
        stemThickness * graceNoteScale
    }

    var graceNoteBeamThickness: Double {
        beamThickness * graceNoteScale
    }

    var graceNoteBeamBeamSpacing: Double {
        beamSpacing * graceNoteScale
    }
    
    fileprivate mutating func configure(dictionary: [String: Any], assertAllValuesPresent: Bool) {
        
        func apply<T>(_ keypath: WritableKeyPath<Self, T>, _ key: String) {
            if let v = dictionary[key] as? T {
                self[keyPath: keypath] = v
                return
            }
            
            if assertAllValuesPresent {
                assertionFailure("Value: \(key) not present")
            }
        }
        
        apply(\.arrowShaftThickness, "arrowShaftThickness")
        apply(\.barlineSeparation, "barlineSeparation")
        apply(\.beamSpacing, "beamSpacing")
        apply(\.beamThickness, "beamThickness")
        apply(\.bracketThickness, "bracketThickness")
        apply(\.dashedBarlineDashLength, "dashedBarlineDashLength")
        apply(\.dashedBarlineGapLength, "dashedBarlineGapLength")
        apply(\.dashedBarlineThickness, "dashedBarlineThickness")
        apply(\.hairpinThickness, "hairpinThickness")
        apply(\.legerLineExtension, "legerLineExtension")
        apply(\.legerLineThickness, "legerLineThickness")
        apply(\.lyricLineThickness, "lyricLineThickness")
        apply(\.octaveLineThickness, "octaveLineThickness")
        apply(\.pedalLineThickness, "pedalLineThickness")
        apply(\.repeatBarlineDotSeparation, "repeatBarlineDotSeparation")
        apply(\.repeatEndingLineThickness, "repeatEndingLineThickness")
        apply(\.slurEndpointThickness, "slurEndpointThickness")
        apply(\.slurMidpointThickness, "slurMidpointThickness")
        apply(\.staffLineThickness, "staffLineThickness")
        apply(\.stemThickness, "stemThickness")
        apply(\.subBracketThickness, "subBracketThickness")
        apply(\.textEnclosureThickness, "textEnclosureThickness")
        apply(\.thickBarlineThickness, "thickBarlineThickness")
        apply(\.thinBarlineThickness, "thinBarlineThickness")
        apply(\.tieEndpointThickness, "tieEndpointThickness")
        apply(\.tieMidpointThickness, "tieMidpointThickness")
        apply(\.tupletBracketThickness, "tupletBracketThickness")
    }
}

// MARK: - Anchors

extension Font {
    
    func anchor(forGlyphName glyphName: String, anchorName: String) -> Vector2D? {
        
        guard let anchorsDict = metadata["glyphsWithAnchors"] as? [String: Any] else {
            return nil
        }
        
        guard let glyphDict = anchorsDict[glyphName] as? [String: Any] else {
            return nil
        }
        
        guard let stemUpSEArray = glyphDict[anchorName] as? [Double] else {
            return nil
        }
        
        guard let x = stemUpSEArray[maybe: 0], let y = stemUpSEArray[maybe: 1] else {
            return nil
        }
        
        return Vector2D(x, y)
    }
    
}
