//
//  MeditationLibrary.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import Foundation

protocol MeditationRepository {
//    var meditationTopicsPublisher: AnyPublisher<[Topic], Error> { get }
    func fetchMeditationTopics() -> AnyPublisher<[Topic], Error>
}

class MeditationLibrary {
    private let repo: MeditationRepository
    private var meditationTopicsSubject = CurrentValueSubject<[Topic], Error> ([])
    private var subscriptions = Set<AnyCancellable>()
    
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
}
