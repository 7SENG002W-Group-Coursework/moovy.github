//
//  ShowDetailsViewModel.swift
//  moovy
//
//  Created by Anthony Gibah on 5/12/24.
//

import Foundation
import UIKit
import Combine

class ShowDetailsViewModel: ObservableObject {
    @Published var showDetails: TvSeries? = nil
    @Published var posterPathImage: UIImage? = nil
    @Published var backdropPathImage: UIImage? = nil
    @Published var posterImage: UIImage? = nil
    @Published var errorOccurred: Bool = false
    @Published var errorMessage: String = ""
    @Published var genreName: String = ""
    var cancellables = Set<AnyCancellable>()
    
    private let showDetailsURLString = "\(BaseApi.showDetails)"
    private let token = "\(BaseApi.apiKey)"
    
    func fetchShowDetails(showId: Int, completion: @escaping () -> Void) async {
        print("In Here Show======= \(showId)")
        guard var components = URLComponents(string: showDetailsURLString) else {
            print("Invalid URL")
            return
        }
        
        // Append the show ID to the path
        components.path.append("/\(showId)")
        
        // Add query items
        components.queryItems = [
            URLQueryItem(name: "include_adult", value: "true")
        ]
        
        // Validate the final URL
        guard let url = components.url else {
            print("Invalid URL with components")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to fetch data: HTTP \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                DispatchQueue.main.async {
                    self.errorOccurred = true
                    self.errorMessage = "Failed to load trending shows"
                }
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatterUtils.moovyDateFormat)
            let decodedData = try decoder.decode(TvSeries.self, from: data)
            
            DispatchQueue.main.async {
                self.showDetails = decodedData
                self.errorOccurred = false
                self.errorMessage = ""
                completion()
            }
        } catch {
            print("Error fetching trending: \(error)")
            DispatchQueue.main.async {
                self.errorOccurred = true
                self.errorMessage = "Error fetching trending shows"
                completion()
            }
        }
    }
    func loadImage(from urlString: String) {
        guard let url = URL(string: BaseApi.imageUrl + urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.posterPathImage = $0 }
            .store(in: &cancellables)
    }
    
    func loadImagePosterImage(from urlString: String) async {
        guard let url = URL(string: BaseApi.imageUrl + urlString) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.posterImage = image
                }
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }

    func loadImageBackdropImage(from urlString: String) async {
        guard let url = URL(string: BaseApi.imageUrl + urlString) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.backdropPathImage = image
                }
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }

    
    func fetchGenreName(genreIds: [Int], mediaType: String) {
        guard let firstGenreId = genreIds.first else {
            DispatchQueue.main.async {
                self.genreName = "Genre not found"
            }
            return
        }
        
        Task {
            let fetchedGenreName = await getShowGenre(id: firstGenreId, mediaType: mediaType)
            DispatchQueue.main.async {
                self.genreName = fetchedGenreName ?? "Genre not found"
            }
        }
    }
    
    func getShowGenre(id: Int, mediaType: String) async -> String? {
        let baseUrl = mediaType == "tv" ? BaseApi.tvGenre : BaseApi.movieGenre
        guard let components = URLComponents(string: baseUrl) else {
            print("Invalid URL")
            return nil
        }
        
        // Add query items
        var updatedComponents = components
        updatedComponents.queryItems = [
            URLQueryItem(name: "language", value: "en")
        ]
        
        // Validate the final URL
        guard let url = updatedComponents.url else {
            print("Invalid URL with components")
            return nil
        }
        
        // Prepare the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to fetch data: HTTP \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return nil
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatterUtils.moovyDateFormat)
            let decodedData = try decoder.decode(GenresResponseData.self, from: data)
            
            
            for genre in decodedData.genres {
                if genre.id == id {
                    return genre.name
                }
            }
            
            return nil
        } catch {
            print("Error fetching genres: \(error)")
            return nil
        }
    }
}
    
