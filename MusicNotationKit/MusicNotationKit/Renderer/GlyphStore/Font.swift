//
//  Font.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

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
    
    // SMuFL values. Uses Bravura values as default
    var arrowShaftThickness: Double = 0.16
    var barlineSeparation: Double =  0.4
    var beamSpacing: Double = 0.25
    var beamThickness: Double =  0.5
    var bracketThickness: Double =  0.5
    var dashedBarlineDashLength: Double =  0.5
    var dashedBarlineGapLength: Double = 0.25
    var dashedBarlineThickness: Double = 0.16
    var hairpinThickness: Double = 0.16
    var legerLineExtension: Double =  0.4
    var legerLineThickness: Double = 0.16
    var lyricLineThickness: Double = 0.16
    var octaveLineThickness: Double = 0.16
    var pedalLineThickness: Double = 0.16
    var repeatBarlineDotSeparation: Double = 0.16
    var repeatEndingLineThickness: Double = 0.16
    var slurEndpointThickness: Double =  0.1
    var slurMidpointThickness: Double = 0.22
    var staffLineThickness: Double = 0.13
    var stemThickness: Double = 0.12
    var subBracketThickness: Double = 0.16
    var textEnclosureThickness: Double = 0.16
    var thickBarlineThickness: Double =  0.5
    var thinBarlineThickness: Double = 0.16
    var tieEndpointThickness: Double =  0.1
    var tieMidpointThickness: Double = 0.22
    var tupletBracketThickness: Double =  0.1

    // Additional values (not in the SMuFL spec)
    var graceNoteScale: Double = 0.5

    // Computed values
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
