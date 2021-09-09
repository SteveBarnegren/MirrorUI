import Foundation

class Deeplink {
    
    private var components: [String]
    
    init(path: String) {
        components = path.components(separatedBy: "/")
    }
    
    func nextPathComponent() -> String? {
        if components.isEmpty {
            return nil
        } else {
            return components.removeFirst()
        }
    }
}
