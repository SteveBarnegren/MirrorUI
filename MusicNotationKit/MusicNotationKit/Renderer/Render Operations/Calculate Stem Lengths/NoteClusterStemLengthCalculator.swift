//
//  NoteClusterStemLengthCalculator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 25/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

private let preferredStemLength = 3.5 // One octave

class NoteClusterStemLengthCalculator<T> {
    
    // MARK: - Types
    
    struct Transformer<T> {
        let position: (T) -> Point
        let stemEndOffset: (T) -> Double
        let stemDirection: (T) -> StemDirection
        let setStemLength: (T, Double) -> Void
    }
    
    // MARK: - Properties
    
    private let tf: Transformer<T>
    
    // MARK: - Init
    
    init(transformer: Transformer<T>) {
        self.tf = transformer
    }
    
    // MARK: - Process
    
    func process(noteCluster: [T]) {
        
        if noteCluster.count <= 1 {
            noteCluster.forEach { tf.setStemLength($0, preferredStemLength) }
            return
        }
        
        // If the cluster creates a concave shape, then a horizontal beam should be used
        if isConcave(cluster: noteCluster) {
            applyHorizontalBeaming(to: noteCluster)
        } else {
            applySlantedBeaming(to: noteCluster)
        }
    }
    
    private func applyHorizontalBeaming(to noteCluster: [T]) {
        
        let minY = noteCluster.map { tf.position($0).y - preferredStemLength }.min()!
        for note in noteCluster {
            let length = tf.position(note).y  - minY
            tf.setStemLength(note, length)
        }
    }
    
    private func applySlantedBeaming(to noteCluster: [T]) {
        
        // First and last notes should be the preferred length
        let firstNote = noteCluster.first!
        let lastNote = noteCluster.last!
        [firstNote, lastNote].forEach { tf.setStemLength($0, preferredStemLength) }
        
        // Middle notes should be between first and last values
        let firstY = tf.position(firstNote).y + tf.stemEndOffset(firstNote)
        let lastY = tf.position(lastNote).y  + tf.stemEndOffset(lastNote)
        
        for note in noteCluster.dropFirst().dropLast() {
            let xPct = tf.position(note).x.pct(between: tf.position(firstNote).x, and: tf.position(lastNote).x)
            let stemEnd = firstY + (lastY-firstY)*xPct
            let length = (stemEnd - tf.position(note).y).inverted(if: { tf.stemDirection(note) == .down })
            tf.setStemLength(note, length)
        }
    }
    
    private func isConcave(cluster: [T]) -> Bool {
        
        if cluster.count <= 2 {
            return false
        }
        
        let firstNote = cluster.first!
        let lastNote = cluster.last!
        
        for note in cluster.dropFirst().dropLast() {
            let xPct = tf.position(note).x
                .pct(between: tf.position(firstNote).x, and: tf.position(lastNote).x)
            let yLerp = tf.position(firstNote).y
                .lerp(to: tf.position(lastNote).y, t: xPct)
            
            // Check if the position is above or below the lerped position.
            // Add half a pitch increment to avoid rounding errors.
            if (tf.stemDirection(note) == .up && tf.position(note).y > yLerp - 0.25)
                || (tf.stemDirection(note) == .down && tf.position(note).y < yLerp + 0.25) {
                return true
            }
        }
        
        return false
    }

}

