//
//  MeditationLibrary.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import Foundation

struct Topic {
    let id: UUID
    let title: String
    let isFeatured: Bool
    var isSubtopic: Bool
    private let position: Int
    private let subtopics: [Topic]
    private let meditations: [UUID]
    
    var numberOfMeditations: Int {
        subtopics.map { $0.numberOfMeditations }.reduce(meditations.count, +)
    }
    
    init(
        id: UUID,
        title: String,
        isFeatured: Bool,
        isSubtopic: Bool,
        position: Int,
        subtopics: [Topic],
        meditations: [UUID]
    ) {
        self.id = id
        self.title = title
        self.isFeatured = isFeatured
        self.isSubtopic = isSubtopic
        self.position = position
        self.subtopics = subtopics
        self.meditations = meditations
    }
}

extension Topic : Equatable {}
extension Topic : Comparable {
    static func < (lhs: Topic, rhs: Topic) -> Bool {
        lhs.position < rhs.position
    }
    
    
}

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
