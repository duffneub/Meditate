//
//  TopicViewModel.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import Foundation

class TopicViewModel {
    private let topic: Topic
    private let useCase: BrowseMeditationsUseCaseProtocol
    
    init(_ topic: Topic, useCase: BrowseMeditationsUseCaseProtocol) {
        self.topic = topic
        self.useCase = useCase
    }
    
    var title: String {
        topic.title
    }
    
    var description: String {
        topic.description
    }
    
    var meditationSections: [Section] {
        var sections = topic.subtopics.map {
            Section($0, useCase: useCase)
        }
        if topic.hasMeditations {
            sections.append(Section.generic(topic, useCase: useCase))
        }
        return sections
    }
    
    class Section : ObservableObject, Identifiable {
        private let isGeneric: Bool
        private let topic: Topic
        private let useCase: BrowseMeditationsUseCaseProtocol
        private var subscriptions = Set<AnyCancellable>()
        @Published var meditations: [Meditation] = []
        
        private var titleOverride: String?
        
        init(_ topic: Topic, useCase: BrowseMeditationsUseCaseProtocol) {
            self.isGeneric = false
            self.topic = topic
            self.useCase = useCase
        }
        
        static func generic(_ topic: Topic, useCase: BrowseMeditationsUseCaseProtocol) -> Section {
            let section = Section(topic, useCase: useCase)
            section.titleOverride = "Meditations"
            
            return section
        }
        
        var title: String {
            titleOverride ?? topic.title
        }
        
        func loadMeditations() {
            useCase.meditations(for: topic)
                .receive(on: DispatchQueue.main)
                .replaceError(with: [])
                .assign(to: \.meditations, on: self)
                .store(in: &subscriptions)
        }
    }
    
}
