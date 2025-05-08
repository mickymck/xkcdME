//
//  Networking.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import Foundation

enum NetworkingError: Error {
    case badURL
    case serverError
    case decodingError
    case unknownError
    
    var message: String {
        switch self {
        case .badURL:
            return "The Comic URL is invalid."
        case .serverError:
            return "There was a Comic server error."
        case .decodingError:
            return "Failed to decode the Comic."
        case .unknownError:
            return "There was an unknown Comic error."
        }
    }
}

protocol ComicFetching {
    func fetchComic(number: Int?) async throws -> Comic
}

extension ComicFetching {
    func fetchComic() async throws -> Comic {
        try await fetchComic(number: nil)
    }
}

struct ComicUrlBuilder {
    private let base = "https://xkcd.com"
    private let pathSuffix = "info.0.json"
    
    func url(for number: Int? = nil) -> URL? {
        let pathComponent = number.map { "/\($0)/" } ?? "/"
        let fullString = base + pathComponent + pathSuffix
        return URL(string: fullString)
    }
}


final class Networking: ComicFetching {
    static let shared = Networking()
    
    private init() {}
    
    func fetchComic(number: Int? = nil) async throws -> Comic {
        
        let builder = ComicUrlBuilder()
        
        guard let url = builder.url(for: number) else {
            throw NetworkingError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.serverError
        }
        
        switch httpResponse.statusCode {
        case (200..<299):
            break
        case (400..<499):
            throw NetworkingError.badURL
        default:
            throw NetworkingError.serverError
        }
        
        do {
            let comic = try JSONDecoder().decode(Comic.self, from: data)
            return comic
        } catch {
            throw NetworkingError.decodingError
        }
    }
}

