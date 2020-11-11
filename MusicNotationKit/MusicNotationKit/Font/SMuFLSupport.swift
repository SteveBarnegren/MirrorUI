//
//  FontLoader.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

struct GlyphInfo {
    var unicode: Unicode.Scalar
    var description: String
}

class SMuFLSupport {
    
    static let shared = SMuFLSupport()
    
    var glyphs = [String: GlyphInfo]()
    
    // MARK: - Init
    
    init() {
        loadGlyphs()
    }
    
    private func loadGlyphs() {
        let json = loadJson(name: "glyphnames")
        var glyphs = [String: GlyphInfo]()
        
        for key in json.keys {
            let value = json[key] as! [String: String]
            
            var unicodeString = value["codepoint"]!
            unicodeString.removeFirst(2)
            let unicodeNum = Int(strtoul(unicodeString, nil, 16))
            let unicodeScalar = UnicodeScalar(unicodeNum)!
            
            glyphs[key] = GlyphInfo(unicode: unicodeScalar,
                                description: value["description"]!)
        }
        
        self.glyphs = glyphs
    }
    
    private func loadJson(name: String) -> [String: Any] {
        let bundle = Bundle(for: SMuFLSupport.self)
        
        guard let fileURL = bundle.url(forResource: name, withExtension: "json") else {
            fatalError("Unable to find \(name).json")
        }
        
        guard let data = try? Data(contentsOf: fileURL) else {
            fatalError("Unable to load \(name).json")
        }
        
        do {
            let any = try JSONSerialization.jsonObject(with: data, options: [])
            let json = any as! [String: Any]
            return json
        } catch {
            fatalError("Error decoding \(name).json - \(error)")
        }
    }
}
