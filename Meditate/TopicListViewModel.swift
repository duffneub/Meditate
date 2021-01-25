//
//  TopicListViewModel.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import SwiftUI

class TopicListViewModel : ObservableObject {
    private let useCase: BrowseMeditationsUseCaseProtocol
    private var subscriptions = Set<AnyCancellable>()
    @Published var topics: [TopicCard] = []
    
    init(useCase: BrowseMeditationsUseCaseProtocol) {
        self.useCase = useCase
        self.useCase.meditationTopics
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .map { $0.map { TopicCard(topic: $0, useCase: useCase) } }
            .assign(to: \.topics, on: self)
            .store(in: &subscriptions)
    }
    
    func loadMeditationTopics() {
        useCase.loadMeditationTopics()
    }
    
    class TopicCard : Identifiable {
        private let topic: Topic
        private let useCase: BrowseMeditationsUseCaseProtocol
        
        var id: UUID {
            topic.id
        }
        
        init(topic: Topic, useCase: BrowseMeditationsUseCaseProtocol) {
            self.topic = topic
            self.useCase = useCase
        }
        
        var destination: some View {
            TopicView(topic: .init(topic, useCase: useCase))
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
