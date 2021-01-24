//
//  Meditation.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Foundation

struct Meditation : Identifiable {
    let id: UUID
    let title: String
    let teacher: String
    let playCount: Int
    
    init(id: UUID, title: String, teacher: String, playCount: Int) {
        self.id = id
        self.title = title
        self.teacher = teacher
        self.playCount = playCount
    }
}

extension Meditation : Equatable {}
extension Meditation : Comparable {
    static func < (lhs: Meditation, rhs: Meditation) -> Bool {
        lhs.playCount > rhs.playCount
    }
}
