//
//  TopicListViewModelTests.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import XCTest
@testable import Meditate

class TopicListViewModelTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    func testLoadMeditationTopics_shouldGetTopicsFromLibrary() throws {
        let library = MockMeditationLibrary()
        let topics = (0..<10).map { _ in Topic.make() }
        library.meditationTopicsResult = .success(topics)
        let sut = TopicListViewModel(library: library)
        
        sut.loadMeditationTopics()
        
        XCTAssertTrue(library.didLoadMeditationTopics)
        XCTAssertEqual(topics, try await(sut.$topics.dropFirst().eraseToAnyPublisher()))
    }
    
    // MARK: - Helper Methods
    
    private func await<Value, Failure : Error>(_ publisher: AnyPublisher<Value, Failure>) throws -> Value {
        var expectation: XCTestExpectation? = self.expectation(description: "To receive values from Publisher")
        var result: Result<Value, Failure>!
        
        var subscription: AnyCancellable?
        let cancelSubscription: () -> Void = {
            subscription?.cancel()
            subscription = nil
        }
        
        subscription = publisher.sink { _ in
        } receiveValue: { value in
            result = .success(value)
            expectation?.fulfill()
            expectation = nil
            cancelSubscription()
        }
        
        waitForExpectations(timeout: 1.0)
        
        return try result.get()
    }
    
}
