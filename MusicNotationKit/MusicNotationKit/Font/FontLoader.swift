import Foundation
import UIKit

class FontLoader {
    
    static var fontsLoaded = false
    
    static func loadFonts() {
        if fontsLoaded {
            return
        }
        
        registerFont(withName: "Bravura", fileExtension: "otf")
        fontsLoaded = true
    }
    
    private static func registerFont(withName name: String, fileExtension: String) {
        let frameworkBundle = Bundle(for: SMuFLSupport.self)
        let pathForResourceString = frameworkBundle.path(forResource: name, ofType: fileExtension)
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>?
        
        if CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false {
            fatalError("Error registering font \(name).\(fileExtension)")
        }
    }
}
