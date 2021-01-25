//
//  TopicView.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import SwiftUI

struct TopicView: View {
    let topic: TopicViewModel

    var body : some View {
        ScrollView {
            Text(topic.description)
            ForEach(topic.meditationSections) { section in
                TopicSectionView(section)
            }
        }
        .padding()
        .navigationTitle(topic.title)
    }
    
    struct TopicSectionView : View {
        @ObservedObject private var section: TopicViewModel.Section
        
        init(_ section: TopicViewModel.Section) {
            self.section = section
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(section.title).font(.title2)
                    Spacer()
                }
                if !section.meditations.isEmpty {
                    VStack(alignment: .leading) {
                        ForEach(section.meditations) { meditation in
                            MeditationCardView(meditation)
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .padding(.vertical)
            .onAppear {
                section.loadMeditations()
            }
            
        }
        
        struct MeditationCardView : View {
            private let meditation: Meditation
            
            init(_ meditation: Meditation) {
                self.meditation = meditation
            }
            
            var body: some View {
                HStack {
                    Thumbnail(meditation.image)
                    VStack(alignment: .leading) {
                        Text(meditation.title)
                            .font(.headline)
                        Text(meditation.teacher)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .frame(height: height)
            }
            
            // MARK: - View Constants
            
            private let height: CGFloat = 50
        }
        
        struct Thumbnail : View {
            private let location: URL?
            @ObservedObject var imageLoader: ImageLoader
            
            init(_ location: URL?) {
                self.location = location
                imageLoader = ImageLoader()
            }
            
            var body: some View {
                Group {
                    if imageLoader.image == nil {
                        Color.secondary
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(cornerRadius)
                    } else if location != nil {
                        Image(uiImage: imageLoader.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(cornerRadius)
                    }
                }.onAppear {
                    if location != nil {
                        imageLoader.loadImage(at: location!)
                    }
                }
            }
            
            // MARK: - View Constants
            
            private let cornerRadius: CGFloat = 6
        }
    }
}

class ImageLoader : ObservableObject {
    private var subscription: AnyCancellable?
    @Published var image: UIImage?
    
    func loadImage(at url: URL) {
        guard subscription == nil else {
            return
        }
        subscription = URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in
                return data
            }
            .map { UIImage(data: $0) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

// MARK: - Preview

struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TopicView(topic: .init(topic, useCase: FakeMeditationLibrary()))
        }
    }
    
    static let topic = Topic(
        id: UUID(),
        title: "Great for Beginners",
        isFeatured: false,
        isSubtopic: false,
        position: 0,
        subtopics: [
            .init(
                id: UUID(),
                title: "For A Quick Session",
                isFeatured: false,
                isSubtopic: false,
                position: 0,
                subtopics: [],
                meditations: [UUID()],
                color: .init(hex: "#000000"),
                description: "",
                parentID: nil),
            .init(
                id: UUID(),
                title: "Focus on Your Breath",
                isFeatured: false,
                isSubtopic: false,
                position: 0,
                subtopics: [],
                meditations: [UUID()],
                color: .init(hex: "#000000"),
                description: "",
                parentID: nil)
        ],
        meditations: [UUID()],
        color: .init(hex: "#000000"),
        description: "A biologist predicts a population bomb that will lead to a global catastrophe. An economist sees a limitless future for mankind. The result is one of the most famous bets in economics.",
        parentID: nil)
    
    class FakeMeditationLibrary : BrowseMeditationsUseCaseProtocol {
        private var topicsSubject = PassthroughSubject<[Topic], Error>()
        
        var meditationTopics: AnyPublisher<[Topic], Error> {
            topicsSubject.eraseToAnyPublisher()
        }
        
        func loadMeditationTopics() {
        }
        
        func meditations(for topic: Topic) -> AnyPublisher<[Meditation], Error> {
            let result: [Meditation] = [
                .init(
                    id: UUID(), title: "Breathing to Release Pain", teacher: "Jeff Warren", image: nil, playCount: 5),
                .init(
                    id: UUID(), title: "Biceps Curl for Your Brain", teacher: "Sharon Salzberg", image: nil, playCount: 4),
                .init(
                    id: UUID(), title: "Winding Down for Sleep", teacher: "Alexis Santos", image: nil, playCount: 3),
                .init(
                    id: UUID(), title: "Investigating Patterns", teacher: "Anushka Fernandopulle", image: nil, playCount: 2),
                .init(
                    id: UUID(), title: "Before the Day Begins", teacher: "Joseph Goldstein", image: nil, playCount: 1),
                
            ]
            
            return Just(result).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}
