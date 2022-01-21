import Foundation

extension Font {
    
    static let bravura: Font = {
       
        guard let url = Bundle.framework.url(forResource: "bravura_metadata", withExtension: "json") else {
            fatalError("Unable to find Bravura metadata")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load Bravura metadata")
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            fatalError("Unable to parse Bravura metadata")
        }
                
        return Font(name: "Bravura", metadata: json)
    }()
}
