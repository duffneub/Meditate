//
//  MeditateApp.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import SwiftUI

@main
struct MeditateApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TopicListView(.init(useCase: BrowseMeditationsUseCase(repo: TenPercentHappierMeditationRepository())))
            }
        }
    }
}
