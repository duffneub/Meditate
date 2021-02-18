//
//  MeditateApp.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import SwiftUI

// By default, use cached json and images
let useRemoteAPI = false

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
