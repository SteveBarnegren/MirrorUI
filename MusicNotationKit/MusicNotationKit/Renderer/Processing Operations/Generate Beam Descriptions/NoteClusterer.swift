import Foundation

class NoteClusterer<T> {
    
    // MARK: - Types
    
    struct Transformer<T> {
        let time: (T) -> Time
    }
    
    // MARK: - Properties
    
    private var tf: Transformer<T>
    
    // MARK: - Init
    
    init(transformer: Transformer<T>) {
        self.tf = transformer
    }
    
    // MARK: - Create Clusters
    
    func clusters(from notes: [T], timeSignature: TimeSignature) -> [[T]] {
        return notes.chunked(atChangeTo: { tf.time($0).convertedTruncating(toDivision: 4).value })
    }
    
}
