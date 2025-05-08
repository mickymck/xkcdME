//
//  XkcdHomeViewModel.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/7/25.
//

import Foundation
import SwiftUI

enum ComicLoadingState: Equatable {
    case idle
    case loading
    case loaded
    case error(NetworkingError)
}

enum UserInputError: Error {
    case badComicNumber
    
    var message: String {
        switch self {
        case .badComicNumber:
            return "There is no Comic with that number."
        }
    }
}

@Observable
final class XkcdHomeViewModel: ObservableObject {
    var comic: Comic?
    var error: UserInputError?
    var state: ComicLoadingState = .idle
    
    let networking: ComicFetching
    
    init(networking: ComicFetching = Networking.shared) {
        self.networking = networking
    }
    
    @MainActor
    func loadInitialComic() async {
        guard comic == nil else { return }
        state = .loading
        await load()
    }
    
    @MainActor
    func load(comic number: Int? = nil) async {
        do {
            self.comic = try await networking.fetchComic()
            state = .loaded
        } catch let networkingError as NetworkingError {
            state = .error(networkingError)
        } catch {
            state = .error(NetworkingError.unknownError)
        }
    }
    
    // TODO: make this non-optional?
    @MainActor
    func isBadNumber(input: Int) -> Bool? {
        if let comic {
            return (input > comic.number || input < 1)
        }
        return nil
    }
}
