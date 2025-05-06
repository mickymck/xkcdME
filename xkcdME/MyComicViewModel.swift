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

@MainActor
@Observable
final class MyComicViewModel: ObservableObject {
    var currentComic: Comic?
    var comic: Comic? {
        didSet {
            print("Comic: \(comic?.title ?? "nil")")
        }
    }
    var errorMessage: String?
    var state: ComicLoadingState = .idle
    
    func load(comic number: Int? = nil) async {
        state = number == nil ? .loadingInitial : .loading
        do {
            if let number {
                self.comic = try await Networking.shared.fetchComic(number: number)
                state = .loaded
                print("Loaded")
            } else {
                self.currentComic = try await Networking.shared.fetchComic()
                state = .loadedInitial
                print("Loaded")
            }
        } catch let comicError as ComicError {
            self.errorMessage = comicError.message
            print("Error: \(comicError.message)")
            state = .error
        } catch {
            self.errorMessage = ComicError.unknownError.message
            state = .error
        }
    }
    
    func goToComic(_ num: Int) async {
        print("Go")
        await load(comic: num)
        print("Loaded?")
    }
    
    func loadInitialComic() async {
        await load()
    }
}

