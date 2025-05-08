//
//  Networking.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import Foundation

protocol ComicError: Error {
    var message: String { get }
}

enum NetworkingError: ComicError {
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

enum UserInputError: ComicError {
    case badComicNumber
    
    var message: String {
        switch self {
        case .badComicNumber:
            return "There is no Comic with that number."
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

