//
//  MyComicViewModel.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import Foundation

enum ComicLoadingState {
    case idle
    case loading
    case loaded
    case error
}

@MainActor
final class MyComicViewModel: ObservableObject {
    @Published var comic: Comic?
    @Published var errorMessage: String?
    @Published var state: ComicLoadingState = .idle
    
    func load(comic number: Int) async {
        state = .loading
        do {
            self.comic = try await Networking.shared.fetchComic(number: number)
            state = .loaded
        } catch let comicError as ComicError {
            self.errorMessage = comicError.message
            state = .error
        } catch {
            self.errorMessage = ComicError.unknownError.message
            state = .error
        }
    }
}

