//
//  Meditation+TestHelpers.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import Foundation
@testable import Meditate

extension Meditation {
    static func make(
        id: UUID = UUID(),
        title: String = "",
        teacher: String = "",
        image: URL? = nil,
        backgroundImage: URL? = nil,
        playCount: Int = 0
    ) -> Meditation {
        .init(
            id: id,
            title: title,
            teacher: teacher,
            image: image,
            backgroundImage: backgroundImage,
            playCount: playCount)
    }
}
