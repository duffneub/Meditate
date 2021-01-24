//
//  Topic+TestHelpers.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import Foundation
@testable import Meditate

extension Topic {
    static func make(
        id: UUID = UUID(),
        title: String = "",
        isFeatured: Bool = false,
        isSubtopic: Bool = false,
        position: Int = 0,
        subtopics: [Topic] = [],
        meditations: [UUID] = [],
        color: Color = .init(hex: "#000000")
    ) -> Topic {
        .init(
            id: id,
            title: title,
            isFeatured: isFeatured,
            isSubtopic: isSubtopic,
            position: position,
            subtopics: subtopics,
            meditations: meditations,
            color: color)
    }
}
