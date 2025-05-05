//
//  MyComicViewModel.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import Foundation

@MainActor
final class MyComicViewModel: ObservableObject {
    @Published var comic: Comic? {
        didSet {
            print("\(comic?.title ?? "")")
        }
    }
    @Published var errorMessage: String?
    
    func load(comic number: Int) async {
        do {
            self.comic = try await Networking.shared.fetchComic(number: number)
        } catch let comicError as ComicError {
            print(comicError.message)
            self.errorMessage = comicError.message
        } catch {
            self.errorMessage = ComicError.unknownError.message
        }
    }
}

