//
//  MockComicFetch.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/6/25.
//

import Foundation

final class MockNetworking: ComicFetching {
    
    let result: Result<Comic, ComicError>
    
    init(result: Result<Comic, ComicError>) {
        self.result = result
    }
    
    func fetchComic(number: Int?) async throws -> Comic {
        switch result {
        case .success(let comic):
            return comic
        case .failure(let error):
            throw error
        }
    }
}
