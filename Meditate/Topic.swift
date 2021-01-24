//
//  Topic.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Foundation

struct Topic {
    let id: UUID
    let title: String
    let isFeatured: Bool
    var isSubtopic: Bool
    private let position: Int
    private let subtopics: [Topic]
    private let meditations: [UUID]
    let color: Color
    
    var numberOfMeditations: Int {
        subtopics.map { $0.numberOfMeditations }.reduce(meditations.count, +)
    }
    
    init(
        id: UUID,
        title: String,
        isFeatured: Bool,
        isSubtopic: Bool,
        position: Int,
        subtopics: [Topic],
        meditations: [UUID],
        color: Color
    ) {
        self.id = id
        self.title = title
        self.isFeatured = isFeatured
        self.isSubtopic = isSubtopic
        self.position = position
        self.subtopics = subtopics
        self.meditations = meditations
        self.color = color
    }
    
    func includes(_ meditation: Meditation) -> Bool {
        meditations.contains(meditation.id)
    }
    
    struct Color {
        let red: Int
        let green: Int
        let blue: Int
        
        init(hex: String) {
            guard let hexValue = Int(
                    hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted), radix: 16),
                  hexValue <= 0xFFFFFF
            else {
                red = 0
                green = 0
                blue = 0
                return
            }
            self.red = (hexValue >> 16) & 0xFF
            self.green = (hexValue >> 8) & 0xFF
            self.blue = hexValue & 0xFF
        }
    }
}

extension Topic.Color : Equatable {}
extension Topic : Identifiable {}
extension Topic : Equatable {}
extension Topic : Comparable {
    static func < (lhs: Topic, rhs: Topic) -> Bool {
        lhs.position < rhs.position
    }
    
    
}
