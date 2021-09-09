import Foundation

extension Sequence {
    
    func toAnySequence() -> AnySequence<Element> {
        return AnySequence(self)
    }
}
