//
//  MockBrowseMeditationsUseCase.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import Foundation
@testable import Meditate

class MockBrowseMeditationsUseCase : BrowseMeditationsUseCaseProtocol {
    private var topicMeditationsResults: [UUID: Result<[Meditation], Error>] = [:]
    var meditationTopicsResult: Result<[Topic], Error> = .success([])
    
    private(set) var didLoadMeditationTopics = false
    
    // MARK: - BrowseMeditationsUseCaseProtocol
    
    var meditationTopics: AnyPublisher<[Topic], Error> {
        Future { promise in
            promise(self.meditationTopicsResult)
        }.eraseToAnyPublisher()
    }
    
    func loadMeditationTopics() {
        didLoadMeditationTopics = true
    }

    func meditations(for topic: Topic) -> AnyPublisher<[Meditation], Error> {
        Future { promise in
            promise(self.topicMeditationsResults[topic.id]!)
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Helpers
    
    func setMeditations(for topic: Topic, to result: Result<[Meditation], Error>) {
        topicMeditationsResults[topic.id] = result
    }
}
