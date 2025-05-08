//
//  MyComicViewModel.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import Foundation
import SwiftUI

@Observable
final class MyComicViewModel: ObservableObject {
    var comic: Comic?
    var error: NetworkingError?
    var state: ComicLoadingState = .idle
    
    let networking: ComicFetching
    
    init(networking: ComicFetching = Networking.shared) {
        self.networking = networking
    }
    
    @MainActor
    func getComic(number: Int) async {
        state = .loading
        await load(comic: number)
    }
    
    @MainActor
    func load(comic number: Int) async {
        do {
            self.comic = try await networking.fetchComic(number: number)
            state = .loaded
            error = nil
        } catch let networkingError as NetworkingError {
            self.error = networkingError
            state = .error(networkingError)
        } catch {
            self.error = NetworkingError.unknownError
            state = .error(NetworkingError.unknownError)
        }
    }
}
