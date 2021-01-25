//
//  TopicView.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import SwiftUI

struct TopicView: View {
    let topic: TopicViewModel

    var body : some View {
        ScrollView {
            Text(topic.description)
            ForEach(topic.meditationSections) { section in
                TopicSectionView(section)
            }
        }
        .padding()
        .navigationTitle(topic.title)
    }
    
    struct TopicSectionView : View {
        @ObservedObject private var section: TopicViewModel.Section
        
        init(_ section: TopicViewModel.Section) {
            self.section = section
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(section.title).font(.title2)
                VStack(alignment: .leading) {
                    ForEach(section.meditations) { meditation in
                        MeditationCardView(meditation)
                    }
                }
            }
            .padding(.vertical)
            .onAppear {
                section.loadMeditations()
            }
            
        }
        
        struct MeditationCardView : View {
            private let meditation: Meditation
            
            init(_ meditation: Meditation) {
                self.meditation = meditation
            }
            
            var body: some View {
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
    }
}

struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TopicView(topic: .init(topic, library: FakeMeditationLibrary()))
        }
    }
    
    static let topic = Topic(
        id: UUID(),
        title: "Great for Beginners",
        isFeatured: false,
        isSubtopic: false,
        position: 0,
        subtopics: [
            .init(
                id: UUID(),
                title: "For A Quick Session",
                isFeatured: false,
                isSubtopic: false,
                position: 0,
                subtopics: [],
                meditations: [UUID()],
                color: .init(hex: "#000000"),
                description: ""),
            .init(
                id: UUID(),
                title: "Focus on Your Breath",
                isFeatured: false,
                isSubtopic: false,
                position: 0,
                subtopics: [],
                meditations: [UUID()],
                color: .init(hex: "#000000"),
                description: "")
        ],
        meditations: [UUID()],
        color: .init(hex: "#000000"),
        description: "A biologist predicts a population bomb that will lead to a global catastrophe. An economist sees a limitless future for mankind. The result is one of the most famous bets in economics.")
    
    class FakeMeditationLibrary : IMeditationLibrary {
        private var topicsSubject = PassthroughSubject<[Topic], Error>()
        
        var meditationTopics: AnyPublisher<[Topic], Error> {
            topicsSubject.eraseToAnyPublisher()
        }
        
        func loadMeditationTopics() {
        }
        
        func meditations(for topic: Topic) -> AnyPublisher<[Meditation], Error> {
            let result: [Meditation] = [
                .init(id: UUID(), title: "Breathing to Release Pain", teacher: "Jeff Warren", playCount: 5),
                .init(id: UUID(), title: "Biceps Curl for Your Brain", teacher: "Sharon Salzberg", playCount: 4),
                .init(id: UUID(), title: "Winding Down for Sleep", teacher: "Alexis Santos", playCount: 3),
                .init(id: UUID(), title: "Investigating Patterns", teacher: "Anushka Fernandopulle", playCount: 2),
                .init(id: UUID(), title: "Before the Day Begins", teacher: "Joseph Goldstein", playCount: 1),
                
            ]
            
            return Just(result).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}
