//
//  TopicViewModelSectionTests.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import XCTest
@testable import Meditate

class TopicViewModelSectionTests: XCTestCase {
    private let library = MockMeditationLibrary()
    private var subscriptions = Set<AnyCancellable>()

    func testTitle_shouldMatchTopicTitle() {
        let topic = Topic.make(title: "A title")
        let sut = TopicViewModel.Section(topic, library: library)
        
        XCTAssertEqual(topic.title, sut.title)
    }
    
    func testTitle_withGenericSection_shouldBeMeditations() {
        let topic = Topic.make(title: "A title")
        let sut = TopicViewModel.Section.generic(topic, library: library)
        
        XCTAssertEqual("Meditations", sut.title)
    }
    
    func testMeditations_shouldGetMeditationsFromLibrary() {
        let meditations = (0..<10).map { _ in Meditation.make() }
        let topic = Topic.make(meditations: meditations.map { $0.id })
        library.setMeditations(for: topic, to: .success(meditations))
        let sut = TopicViewModel.Section(topic, library: library)
        sut.loadMeditations()
        
        XCTAssertEqual(meditations, try await(sut.$meditations.eraseToAnyPublisher()))
    }
    
    
    // MARK: - Helper Methods
    
    private func await<Value, Failure : Error>(_ publisher: AnyPublisher<Value, Failure>) throws -> Value {
        let expectation = self.expectation(description: "To receive values from Publisher")
        var result: Result<Value, Failure>!
        
        var subscription: AnyCancellable?
        let cancelSubscription: () -> Void = {
            subscription?.cancel()
            subscription = nil
        }
        
        subscription = publisher.sink { _ in
        } receiveValue: { value in
            result = .success(value)
            expectation.fulfill()
            cancelSubscription()
        }
        
        waitForExpectations(timeout: 1.0)
        
        return try result.get()
    }
    
}

class MockMeditationLibrary : IMeditationLibrary {
    private var topicMeditationsResults: [UUID: Result<[Meditation], Error>] = [:]
    
    // MARK: - IMeditationLibrary

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