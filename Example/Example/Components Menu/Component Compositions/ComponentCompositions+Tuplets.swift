import Foundation
import MusicNotationKit

extension ComponentCompositions {
    
    static var tuplets: Composition {
        
        let stave = Stave()

        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .crotchet, pitch: .c4))
            
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            
            sequence.startTuplet(TupletTime(value: 2, over: 3))// triplet
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.endTuplet()

            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.startTuplet(TupletTime(value: 2, over: 3))// triplet
            sequence.add(note: Note(value: .quaver, pitch: .f3))
            sequence.add(note: Note(value: .quaver, pitch: .f3))
            sequence.add(note: Note(value: .quaver, pitch: .f3))
            sequence.endTuplet()
            
            sequence.startTuplet(TupletTime(value: 2, over: 3))// triplet
            sequence.add(note: Note(value: .quaver, pitch: .f3))
            sequence.add(note: Note(value: .quaver, pitch: .a4))
            sequence.add(note: Note(value: .quaver, pitch: .c4))
            sequence.endTuplet()
            
            sequence.startTuplet(TupletTime(value: 2, over: 3))// triplet
            sequence.add(note: Note(value: .quaver, pitch: .e4))
            sequence.add(note: Note(value: .quaver, pitch: .e4))
            sequence.add(note: Note(value: .quaver, pitch: .e4))
            sequence.endTuplet()
            
            sequence.startTuplet(TupletTime(value: 2, over: 3))// triplet
            sequence.add(note: Note(value: .quaver, pitch: .e4))
            sequence.add(note: Note(value: .quaver, pitch: .f3))
            sequence.add(note: Note(value: .quaver, pitch: .f3))
            sequence.endTuplet()
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .crotchet, pitch: .f3))
            
            sequence.add(note: Note(value: .semiquaver, pitch: .f3))
            sequence.add(note: Note(value: .semiquaver, pitch: .a4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))

            sequence.startTuplet(TupletTime(value: 4, over: 6)) // sixtuplet
            sequence.add(note: Note(value: .semiquaver, pitch: .f3))
            sequence.add(note: Note(value: .semiquaver, pitch: .a4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))
            sequence.endTuplet()
            
            sequence.startTuplet(TupletTime(value: 2, over: 3))
            sequence.add(note: Note(value: .quaver, pitch: .e4))
            sequence.add(rest: Rest(value: .quaver))
            sequence.add(note: Note(value: .quaver, pitch: .f3))
            sequence.endTuplet()
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        do {
            let bar = Bar()
            
            do {
                let sequence = NoteSequence()
                
                sequence.startTuplet(TupletTime(value: 2, over: 3)) // sixtuplet
                sequence.add(note: Note(value: .crotchet, pitch: .c4))
                sequence.add(note: Note(value: .crotchet, pitch: .c4))
                sequence.add(note: Note(value: .crotchet, pitch: .c4))
                sequence.endTuplet()

                sequence.startTuplet(TupletTime(value: 4, over: 6)) // sixtuplet
                sequence.add(note: Note(value: .semiquaver, pitch: .f3))
                sequence.add(rest: Rest(value: .semiquaver))
                sequence.add(note: Note(value: .semiquaver, pitch: .c4))
                sequence.add(note: Note(value: .semiquaver, pitch: .c4))
                sequence.add(rest: Rest(value: .semiquaver))
                sequence.add(note: Note(value: .semiquaver, pitch: .c4))
                sequence.endTuplet()
                
                sequence.startTuplet(TupletTime(value: 4, over: 6)) // sixtuplet
                sequence.add(note: Note(value: .semiquaver, pitch: .f3))
                sequence.add(rest: Rest(value: .semiquaver))
                sequence.add(note: Note(value: .semiquaver, pitch: .c4))
                sequence.add(note: Note(value: .semiquaver, pitch: .c4))
                sequence.add(rest: Rest(value: .semiquaver))
                sequence.add(note: Note(value: .semiquaver, pitch: .c4))
                sequence.endTuplet()
                
                bar.add(sequence: sequence)
            }
            
            do {
                let sequence2 = NoteSequence()
                
                sequence2.add(note: Note(value: .quaver, pitch: .f3))
                sequence2.add(note: Note(value: .quaver, pitch: .f3))
                sequence2.add(note: Note(value: .quaver, pitch: .f3))
                sequence2.add(note: Note(value: .quaver, pitch: .f3))
                
                bar.add(sequence: sequence2)
            }
            
            stave.add(bar: bar)
        }
        
        do {
            let bar = Bar()
            let sequence = NoteSequence()
            
            sequence.add(note: Note(value: .crotchet, pitch: .f3))
            
            sequence.add(note: Note(value: .semiquaver, pitch: .f3))
            sequence.add(note: Note(value: .semiquaver, pitch: .a4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))

            sequence.startTuplet(TupletTime(value: 4, over: 5)) // quintuplet
            sequence.add(note: Note(value: .semiquaver, pitch: .f3))
            sequence.add(note: Note(value: .semiquaver, pitch: .a4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))
            sequence.add(note: Note(value: .semiquaver, pitch: .c4))
            sequence.endTuplet()
            
            sequence.startTuplet(TupletTime(value: 2, over: 3))
            sequence.add(note: Note(value: .quaver, pitch: .e4))
            sequence.add(rest: Rest(value: .quaver))
            sequence.add(note: Note(value: .quaver, pitch: .f3))
            sequence.endTuplet()
            
            bar.add(sequence: sequence)
            stave.add(bar: bar)
        }
        
        let composition = Composition()
        composition.add(stave: stave)
        return composition
       
    }
    
}
