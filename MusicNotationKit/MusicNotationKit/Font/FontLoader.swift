//
//  FontLoader.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

struct Glyph {
    var unicode: Unicode.Scalar
    var description: String
}

class FontLoader {
    
    static let shared = FontLoader()
    
    var glyphs = [String: Glyph]()
    
    // MARK: - Init
    
    init() {
        UIFont.loadFonts()
        loadGlyphs()
        dump(glyphs)
    }
    
    func go() {
        print("hello")
    }
    
    private func loadGlyphs() {
        let json = loadJson(name: "glyphnames")
        var glyphs = [String: Glyph]()
        
        for key in json.keys {
            let value = json[key] as! [String: String]
            
            var unicodeString = value["codepoint"]!
            unicodeString.removeFirst(2)
            let unicodeNum = Int(strtoul(unicodeString, nil, 16))
            let unicodeScalar = UnicodeScalar(unicodeNum)!
            
            glyphs[key] = Glyph(unicode: unicodeScalar,
                                description: value["description"]!)
        }
        
        self.glyphs = glyphs
    }
    
    private func loadJson(name: String) -> [String: Any] {
        let bundle = Bundle(for: FontLoader.self)
        
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

extension UIFont {
    private static func registerFont(withName name: String, fileExtension: String) {
        let frameworkBundle = Bundle(for: FontLoader.self)
        let pathForResourceString = frameworkBundle.path(forResource: name, ofType: fileExtension)
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>?

        if CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false {
            print("Error registering font")
        }
    }

    public static func loadFonts() {
        registerFont(withName: "Bravura", fileExtension: "otf")
    }
}
