//
//  MeditateTests.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import XCTest
@testable import Meditate

class MeditateTests: XCTestCase {
    private let repo = MockMeditationRepo()
    private var sut: MeditationLibrary!
    private var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        sut = MeditationLibrary(repo: repo)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Get Meditation Topics
    
    func testGetMeditationTopics_shouldOnlyIncludeFeaturedAndParentLevelTopics() throws {
        let topLevel = Topic.make()
        let subtopic = Topic.make(isSubtopic: true)
        let featuredSubtopic = Topic.make(isFeatured: true, isSubtopic: true)
        let featuredTopLevel = Topic.make(isFeatured: true)
        repo.fetchMeditationsTopicResult = .success([topLevel, subtopic, featuredSubtopic, featuredTopLevel])
        
        sut.loadMeditationTopics()
        let topics = try await(sut.meditationTopics)

        XCTAssertEqual(3, topics.count)
    }
    
    func testGetMeditationTopics_shouldBeOrderedByTopicPosition() throws {
        let first = Topic.make(position: 1)
        let second = Topic.make(position: 2)
        let third = Topic.make(position: 3)
        
        repo.fetchMeditationsTopicResult = .success([second, third, first])
        
        sut.loadMeditationTopics()
        let topics = try await(sut.meditationTopics)
        
        XCTAssertEqual(first, topics[0])
        XCTAssertEqual(second, topics[1])
        XCTAssertEqual(third, topics[2])
    }
    
    // MARK: - Get Meditations for Topic
    
    func testMeditationsForTopic_shouldReturnMeditationsMatchingIDsOfTopicsMeditations() throws {
        let meditationIds = (0..<10).map { _ in UUID() }
        let meditations = meditationIds.map { Meditation.make(id: $0) }
        repo.fetchMeditationsResult = .success(meditations)
        
        let topic = Topic.make(meditations: meditationIds)
        
        XCTAssertEqual(meditations, try await(sut.meditations(for: topic)))
    }
    
    func testMeditationsForTopic_shouldCacheResults() throws {
        let meditationIds = (0..<10).map { _ in UUID() }
        let meditations = meditationIds.map { Meditation.make(id: $0) }
        repo.fetchMeditationsResult = .success(meditations)
        
        let topic = Topic.make(meditations: meditationIds)
        
        XCTAssertEqual(meditations, try await(sut.meditations(for: topic)))
        
        repo.fetchMeditationsResult = .success([])
        
        XCTAssertEqual(meditations, try await(sut.meditations(for: topic)))
    }
    
    func testMeditationsForTopic_shouldBeOrderedByPlayCountInDescendingOrder() throws {
        let first = Meditation.make(playCount: 3)
        let second = Meditation.make(playCount: 2)
        let third = Meditation.make(playCount: 1)
        
        repo.fetchMeditationsResult = .success([second, third, first])
        
        let topic = Topic.make(meditations: [second, third, first].map { $0.id })
        XCTAssertEqual([first, second, third], try await(sut.meditations(for: topic)))
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

class MockMeditationRepo : MeditationRepository {
    var fetchMeditationsTopicResult: Result<[Topic], Error> = .success([])
    var fetchMeditationsResult: Result<[Meditation], Error> = .success([])
    
    // MARK: - MeditationRepository
    
    func fetchMeditationTopics() -> AnyPublisher<[Topic], Error> {
        Future { promise in
            promise(self.fetchMeditationsTopicResult)
        }.eraseToAnyPublisher()
    }
    
    func fetchMeditations() -> AnyPublisher<[Meditation], Error> {
        Future { promise in
            promise(self.fetchMeditationsResult)
        }.eraseToAnyPublisher()
    }
}
