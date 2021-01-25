//
//  TopicListViewModel.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import SwiftUI

class TopicListViewModel : ObservableObject {
    let library: IMeditationLibrary
    private var subscriptions = Set<AnyCancellable>()
    @Published var topics: [TopicCard] = []
    
    init(library: IMeditationLibrary) {
        self.library = library
        self.library.meditationTopics
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .map { $0.map { TopicCard(topic: $0, library: library) } }
            .assign(to: \.topics, on: self)
            .store(in: &subscriptions)
    }
    
    func loadMeditationTopics() {
        library.loadMeditationTopics()
    }
    
    class TopicCard : Identifiable {
        private let topic: Topic
        private let library: IMeditationLibrary
        
        var id: UUID {
            topic.id
        }
        
        init(topic: Topic, library: IMeditationLibrary) {
            self.topic = topic
            self.library = library
        }
        
        var destination: some View {
            TopicView(topic: .init(topic, library: library))
        }
        
        var color: Topic.Color {
            topic.color
        }
        
        var title: String {
            topic.title
        }
        
        var totalNumberOfMeditations: Int {
            topic.totalNumberOfMeditations
        }
    }
}
