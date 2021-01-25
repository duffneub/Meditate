//
//  MeditationRepository.swift
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

class TenPercentHappierMeditationRepository : MeditationRepository {
    private let session = URLSession(configuration: .default)
    private let topicsURL = URL(string: "https://tenpercent-interview-project.s3.amazonaws.com/topics.json")!
    private let meditationsURL = URL(string: "https://tenpercent-interview-project.s3.amazonaws.com/meditations.json")!
    
    func fetchMeditationTopics() -> AnyPublisher<[Topic], Error> {
        struct Response : Decodable {
            let topics: [Topic]
        }
        
        return session.dataTaskPublisher(for: topicsURL)
            .map { data, _ in
                return data
            }
            .decode(type:Response.self, decoder: JSONDecoder())
            .map {
                var map: [UUID: Topic] = [:]
                $0.topics.forEach {
                    map[$0.id] = $0
                }
                $0.topics.filter { $0.parentID != nil }.forEach {
                    guard var parent = map[$0.parentID!] else {
                        return
                    }
                    parent.add($0)
                    map[$0.parentID!] = parent
                }
                
                return Array(map.values)
            }
            .eraseToAnyPublisher()
            
    }
    
    func fetchMeditations() -> AnyPublisher<[Meditation], Error> {
        struct Response : Decodable {
            let meditations: [Meditation]
        }
        
        return session.dataTaskPublisher(for: meditationsURL)
            .map { data, _ in
                return data
            }
            .decode(type:Response.self, decoder: JSONDecoder())
            .map { $0.meditations }
            .eraseToAnyPublisher()
    }
}

extension Topic : Decodable {
    enum CodingKeys : String, CodingKey {
        case id = "uuid"
        case title
        case position
        case parentID = "parent_uuid"
        case meditations
        case featured
        case color
        case description
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let parentID = (try values.decode(String?.self, forKey: .parentID)).map { UUID(uuidString: $0)! }
        
        self.init(
            id: UUID(uuidString: try values.decode(String.self, forKey: .id))!,
            title: try values.decode(String.self, forKey: .title),
            isFeatured: try values.decode(Bool.self, forKey: .featured),
            isSubtopic: parentID == nil,
            position: try values.decode(Int.self, forKey: .position),
            subtopics: [],
            meditations: (try values.decode([String].self, forKey: .meditations)).map { UUID(uuidString: $0)! },
            color:  (try values.decode(String?.self, forKey: .color)).map { .init(hex: $0) } ?? .init(hex: "#000000"),
            description: (try values.decode(String?.self, forKey: .description) ?? ""),
            parentID: parentID)
    }
}

extension Meditation : Decodable {
    enum CodingKeys : String, CodingKey {
        case id = "uuid"
        case title
        case teacher = "teacher_name"
        case image = "image_url"
        case playCount = "play_count"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
        
        self.init(
            id: UUID(uuidString: try values.decode(String.self, forKey: .id))!,
            title: try values.decode(String.self, forKey: .title),
            teacher: try values.decode(String.self, forKey: .teacher),
            playCount: (try values.decode(Int?.self, forKey: .playCount)) ?? 0)
        } catch {
            print(error)
            throw error
        }
    }
}
