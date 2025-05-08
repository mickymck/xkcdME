//
//  XkcdMeViewModel.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/7/25.
//

import Foundation
import SwiftUI

enum ComicLoadingState {
    case idle
    case loading
    case loaded
    case error(ComicError)
}

@Observable
final class XkcdMeViewModel: ObservableObject {
    var comic: Comic?
    var userInputError: UserInputError?
    var state: ComicLoadingState = .idle
    
    let networking: ComicFetching
    
    init(networking: ComicFetching = Networking.shared) {
        self.networking = networking
    }
    
    @MainActor
    func loadInitialComic() async -> Task<Void, Never> {
        guard comic == nil else { return Task {} }
        state = .loading
        return Task {
            await load()
        }
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
    func isBadNumber(input: Int) -> Bool? {
        if let comic {
            return (input > comic.number || input < 1)
        }
        return nil
    }
}
