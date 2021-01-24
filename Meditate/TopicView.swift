//
//  TopicView.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import SwiftUI

class TopicViewModel {
    private let topic: Topic
    
    init(_ topic: Topic) {
        self.topic = topic
    }
    
    var title: String {
        topic.title
    }
    
    var description: String {
        "A biologist predicts a population bomb that will lead to a global catastrophe. An economist sees a limitless future for mankind. The result is one of the most famous bets in economics."
    }
    
    var meditationSections: [MeditationSectionViewModel] {
        [
            .init(title: "For a Quick Session"),
            .init(title: "Focus on Your Breath"),
            .init(title: "Meditations")
        ]
    }
    
    class MeditationSectionViewModel : Identifiable {
        let id = UUID()
        let title: String
        
        init(title: String) {
            self.title = title
        }
        
        var meditations: [Meditation] {
            [
                .init(id: UUID(), title: "Breathing to Release Pain", teacher: "Jeff Warren", playCount: 0),
                .init(id: UUID(), title: "Breathing to Release Pain", teacher: "Jeff Warren", playCount: 0),
                .init(id: UUID(), title: "Breathing to Release Pain", teacher: "Jeff Warren", playCount: 0),
                .init(id: UUID(), title: "Breathing to Release Pain", teacher: "Jeff Warren", playCount: 0),
                .init(id: UUID(), title: "Breathing to Release Pain", teacher: "Jeff Warren", playCount: 0)
            ]
        }
    }
    
}

struct TopicView: View {
    let topic: TopicViewModel

    var body : some View {
        ScrollView {
            Text(topic.description)
            ForEach(topic.meditationSections) { section in
                VStack(alignment: .leading) {
                    Text(section.title).font(.title2)
                    VStack(alignment: .leading) {
                        ForEach(section.meditations) { meditation in
                            HStack {
                                Color.blue
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(6)
                                VStack(alignment: .leading) {
                                    Text(meditation.title)
                                        .font(.headline)
                                    Text(meditation.teacher)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .frame(height: 50)
                        }
                    }
                }.padding(.vertical)
            }
        }
        .padding()
        .navigationTitle(topic.title)
    }
}

struct TopicView_Previews: PreviewProvider {
    static let topics: [Topic] = [
        ("Stress & Anxiety", Topic.Color(hex: "#507992")),
        ("Great for Beginners", Topic.Color(hex: "#148EC0")),
        ("Focus", Topic.Color(hex: "#406DA2")),
        ("Waking Up", Topic.Color(hex: "#30B3D8")),
        ("Happiness", Topic.Color(hex: "#5182DA")),
        ("Relationships", Topic.Color(hex: "#9A5AAF")),
        ("Difficult Emotions", Topic.Color(hex: "#616171")),
        ("Advanced & Unguided", Topic.Color(hex: "#ACBEC3")),
        ("On the Go", Topic.Color(hex: "#3EAC93")),
        ("Uncensored", Topic.Color(hex: "#22222A")),
        ("Health", Topic.Color(hex: "#599CC4"))
    ].enumerated().map { position, tuple in
        Topic.init(
            id: UUID(),
            title: tuple.0,
            isFeatured: false,
            isSubtopic: false,
            position: position,
            subtopics: [],
            meditations: (0..<38).map { _ in UUID() },
            color: tuple.1)}

    static var previews: some View {
        NavigationView {
            TopicView(topic: .init(topics[1]))
        }
    }
}
