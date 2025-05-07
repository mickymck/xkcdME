//
//  Networking.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import Foundation

enum ComicError: Error {
    case badComicNumber
    case badURL
    case serverError
    case decodingError
    case unknownError
    
    var message: String {
        switch self {
        case .badComicNumber:
            return "There is no Comic with that number."
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

final class Networking: ComicFetching {
    static let shared = Networking()
    
    private init() {}
    
    func fetchComic(number: Int? = nil) async throws -> Comic {
        // TODO: get rid of hard-coded string here?
        var urlString = "https://xkcd.com/info.0.json"
        
        if let number {
            urlString = "https://xkcd.com/\(number)/info.0.json"
        }
        
        guard let url = URL(string: urlString) else {
            throw ComicError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ComicError.serverError
        }
        
        do {
            let comic = try JSONDecoder().decode(Comic.self, from: data)
            return comic
        } catch {
            throw ComicError.decodingError
        }
    }
}

