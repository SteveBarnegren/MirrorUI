import Foundation

class CalculatePlayableItemTimesProcessingOperation: CompositionProcessingOperation {
    
    private let playableItemTimeCalculator = PlayableItemTimeCalculator()
    
    func process(composition: Composition) {
        composition.staves.forEach(process)
    }
    
    func process(stave: Stave) {
        var absoluteTime = Time.zero
        for (barIndex, bar) in stave.bars.enumerated() {
            
            var longestSequenceTime = Time.zero
            
            for sequence in bar.sequences {
                var sequenceTime = Time.zero
                for playable in sequence.playables {
                    playable.barTime = sequenceTime
                    playable.compositionTime = CompositionTime(bar: barIndex,
                                                               time: sequenceTime,
                                                               absoluteTime: absoluteTime + sequenceTime)
                    sequenceTime += playable.duration
                }
                longestSequenceTime = max(longestSequenceTime, sequenceTime)
            }
            absoluteTime += longestSequenceTime
        }
    }
}
