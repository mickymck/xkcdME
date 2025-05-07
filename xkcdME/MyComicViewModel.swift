//
//  MyComicViewModel.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import Foundation
import SwiftUI

enum ComicLoadingState {
    case idle
    case loadingInitial
    case loadedInitial
    case loading
    case loaded
    case error
}

@Observable
final class MyComicViewModel: ObservableObject {
    var initialComic: Comic?
    var comic: Comic?
    var errorMessage: String?
    var state: ComicLoadingState = .idle
    
    let networking: ComicFetching
    
    init(networking: ComicFetching = Networking.shared) {
        self.networking = networking
    }
    
    @MainActor
    func load(comic number: Int? = nil) async {
        do {
            if let number {
                self.comic = try await networking.fetchComic(number: number)
                state = .loaded
            } else {
                self.initialComic = try await networking.fetchComic()
                state = .loadedInitial
            }
        } catch let comicError as ComicError {
            self.errorMessage = comicError.message
            state = .error
        } catch {
            self.errorMessage = ComicError.unknownError.message
            state = .error
        }
    }
    
    @MainActor
    func loadInitialComic() -> Task<Void, Never> {
        state = .loadingInitial
        return Task {
            await load()
        }
    }
    
    @MainActor
    func goToComic(_ num: Int) -> Task<Void, Never> {
        state = .loading
        if isBadNumber(input: num) == true {
            errorMessage = ComicError.badComicNumber.message
            state = .error
            return Task {}
        }
        return Task {
            await load(comic: num)
        }
    }
    
    // TODO: make this non-optional?
    func isBadNumber(input: Int) -> Bool? {
        if let initialComic {
            return (input > initialComic.num || input < 1)
        }
        return nil
    }
}
