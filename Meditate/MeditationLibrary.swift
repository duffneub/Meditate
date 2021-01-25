//
//  MeditationLibrary.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import Foundation

protocol MeditationRepository {
    func fetchMeditationTopics() -> AnyPublisher<[Topic], Error>
    func fetchMeditations() -> AnyPublisher<[Meditation], Error>
}

protocol IMeditationLibrary {
    var meditationTopics: AnyPublisher<[Topic], Error> { get }
    func loadMeditationTopics()
    func meditations(for topic: Topic) -> AnyPublisher<[Meditation], Error>
}

class MeditationLibrary : IMeditationLibrary {
    private let repo: MeditationRepository
    private var meditationTopicsSubject = CurrentValueSubject<[Topic], Error> ([])
    private var subscriptions = Set<AnyCancellable>()
    
    private var meditationsCache: [Meditation] = []
    
    init(repo: MeditationRepository) {
        self.repo = repo
    }
    
    var meditationTopics: AnyPublisher<[Topic], Error> {
        meditationTopicsSubject.eraseToAnyPublisher()
    }
    
    func loadMeditationTopics() {
        repo.fetchMeditationTopics()
            .sink { _ in
            } receiveValue: { topics in
                self.meditationTopicsSubject.send(
                    topics.filter { $0.isFeatured || !$0.isSubtopic }.sorted())
            }
            .store(in: &subscriptions)

    }
    
    func meditations(for topic: Topic) -> AnyPublisher<[Meditation], Error> {
        allMeditations.map { meditations in
            meditations
                .filter { topic.includes($0) }
                .sorted()
        }
        .eraseToAnyPublisher()
    }
    
    private var allMeditations: AnyPublisher<[Meditation], Error> {
        guard meditationsCache.isEmpty else {
            return Just(meditationsCache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return repo.fetchMeditations().map {
            self.meditationsCache = $0
            return $0
        }
        .eraseToAnyPublisher()
    }
}
