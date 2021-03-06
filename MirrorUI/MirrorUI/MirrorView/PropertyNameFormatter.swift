//
//  PropertyNameFormatter.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 12/01/2021.
//

import Foundation

private enum CharacterType {
    case regular
    case wordSeparator
}

class PropertyNameFormatter {

    static func displayName(forPropertyName propertyName: String) -> String {
        
        if propertyName.count == 0 {
            return ""
        }
        
        var index = propertyName.startIndex
        
        func next() -> Character? {
            if index < propertyName.endIndex {
                let value = propertyName[index]
                index = propertyName.index(after: index)
                return value
            } else {
                return nil
            }
        }
        
        var displayName = ""
        var startNewWord = true

        var prevChar: Character?
        while let char = next() {

            defer {
                prevChar = char
            }

            if isWordSeparator(char) {
                startNewWord = true
                continue
            }

            if isNewWord(char, prev: prevChar) {
                startNewWord = true
            }

            if startNewWord {
                if !displayName.isEmpty { displayName.append(" ") }
                displayName.append(char.uppercased())
            } else {
                displayName.append(char)
            }

            startNewWord = false
        }
        
        return displayName
    }

    static private func isWordSeparator(_ character: Character) -> Bool {
        return character == "_"
    }

    static private func isNewWord(_ character: Character, prev: Character?) -> Bool {

        if character.isUppercase {
            return true
        }

        if character.isNumber && (prev?.isNumber).isNilOrFalse {
            return true
        }

        return false
    }
}

extension Optional where Wrapped == Bool {

    var isNilOrFalse: Bool {
        switch self {
            case .none:
                return true
            case .some(let v):
                return v == false
        }
    }
}
