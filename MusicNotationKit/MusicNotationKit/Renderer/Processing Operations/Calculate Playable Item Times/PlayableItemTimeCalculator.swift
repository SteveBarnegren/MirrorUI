import Foundation

class PlayableItemTimeCalculator {
    
    func process(noteSequence: NoteSequence) {
        
        var currentTime = Time.zero
        
        for playable in noteSequence.playables {
            playable.barTime = currentTime
            currentTime += playable.duration
        }
    }
}
