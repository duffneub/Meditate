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
    private let library: IMeditationLibrary
    
    init(_ topic: Topic, library: IMeditationLibrary) {
        self.topic = topic
        self.library = library
    }
    
    var title: String {
        topic.title
    }
    
    var description: String {
        topic.description
    }
    
    var meditationSections: [Section] {
        var sections = topic.subtopics.map {
            Section($0, library: library)
        }
        if topic.hasMeditations {
            sections.append(Section.generic(topic, library: library))
        }
        return sections
    }
    
    class Section : ObservableObject, Identifiable {
        private let isGeneric: Bool
        private let topic: Topic
        private let library: IMeditationLibrary
        private var subscriptions = Set<AnyCancellable>()
        @Published var meditations: [Meditation] = []
        
        private var titleOverride: String?
        
        init(_ topic: Topic, library: IMeditationLibrary) {
            self.isGeneric = false
            self.topic = topic
            self.library = library
        }
        
        static func generic(_ topic: Topic, library: IMeditationLibrary) -> Section {
            let section = Section(topic, library: library)
            section.titleOverride = "Meditations"
            
            return section
        }
        
        var title: String {
            titleOverride ?? topic.title
        }
        
        func loadMeditations() {
            library.meditations(for: topic)
                .replaceError(with: [])
                .assign(to: \.meditations, on: self)
                .store(in: &subscriptions)
        }
    }
    
}
