//
//  PropertyNameFormatter.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 12/01/2021.
//

import Foundation

private enum State {
    case wordStart
    case wordEnd
}

class PropertyNameFormatter {

    static func displayName(forPropertyName propertyName: String) -> String {
        
        if propertyName.count == 0 {
            return ""
        }
        
        var index = propertyName.startIndex
        
        func nextChar() -> Character? {
            let nextIndex = propertyName.index(after: index)
            if nextIndex < propertyName.endIndex {
                index = nextIndex
                return propertyName[index]
            } else {
                return nil
            }
        }
        
        var displayName = ""
        var lastWasCapital = false
        
        while let char = nextChar() {
            if char == "_" && !displayName.isEmpty {
                displayName += " "
            } else if char.isLetter && char.isUppercase {
                if !displayName.isEmpty && !lastWasCapital {
                    displayName.append(" ")
                }
                displayName.append(char)
              
                lastWasCapital = true
            } else {
                if displayName.isEmpty {
                    displayName.append(char.uppercased())
                    lastWasCapital = true
                } else {
                    displayName.append(char)
                    lastWasCapital = false
                }
            }
        }
        
        return displayName
    }
    
}
