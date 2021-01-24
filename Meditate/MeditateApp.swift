//
//  MeditateApp.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import SwiftUI

let topics: [Topic] = [
    "Stress & Anxiety",
    "Great for Beginners",
    "Focus",
    "Waking Up",
    "Happiness",
    "Relationships",
    "Difficult Emotions",
    "Advanced & Unguided",
    "On the Go",
    "Uncensored",
    "Health"
].enumerated().map { position, title in
    Topic.init(
        id: UUID(),
        title: title,
        isFeatured: false,
        isSubtopic: false,
        position: position,
        subtopics: [],
        meditations: (0..<38).map { _ in UUID() })}

@main
struct MeditateApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            NavigationView {
                TopicListView(topics: topics)
            }
        }
    }
}
