//
//  TopicTests.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import XCTest
@testable import Meditate

class TopicTests: XCTestCase {
    
    func testTotalNumberOfMeditations_shouldIncludeNumberOfMeditationsWithinThisTopicAndItsSubtopics() throws {
        let child = Topic.make(meditations: (0..<50).map { _ in UUID() })
        let parent = Topic.make(subtopics: [child], meditations: (0..<50).map { _ in UUID() })
        let grandparent = Topic.make(subtopics: [parent], meditations: (0..<100).map { _ in UUID() })
        
        XCTAssertEqual(50, child.totalNumberOfMeditations)
        XCTAssertEqual(100, parent.totalNumberOfMeditations)
        XCTAssertEqual(200, grandparent.totalNumberOfMeditations)
    }
    
}
