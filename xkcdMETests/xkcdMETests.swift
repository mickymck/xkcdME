//
//  xkcdMETests.swift
//  xkcdMETests
//
//  Created by Micky McKeon on 5/5/25.
//

import Foundation
import Testing
@testable import xkcdME

struct xkcdMETests {
    
    @Suite("View Model Tests")
    struct ViewModelStateChangeTests {
        
        let xkcdHomeViewModel = XkcdHomeViewModel(networking: Networking.shared)
        let myComicViewModel = MyComicViewModel(networking: Networking.shared)
        
        @Test func testOriginalState() async throws {
            #expect(xkcdHomeViewModel.comic == nil)
            #expect(xkcdHomeViewModel.state == .idle)
        }
        
        // TODO: think about combining this and the chosenComic success tests into one with parameters
        @Test func testLoadingInitialComic() async throws {
            let initialComicViewModel = XkcdHomeViewModel(networking: MockNetworking(result: .success(MockComic.initial)))
            
            await initialComicViewModel.loadInitialComic()
            
            #expect(initialComicViewModel.comic?.title == MockComic.initial.title)
            #expect(initialComicViewModel.error == nil)
            #expect(initialComicViewModel.state == .loaded)
        }
        
        @Test func testLoadingChosenComic() async throws {
            let chosenComicViewModel = MyComicViewModel(networking: MockNetworking(result: .success(MockComic.chosen)))
            
            await chosenComicViewModel.getComic(number: 55)

            #expect(chosenComicViewModel.comic?.title == MockComic.chosen.title)
            #expect(chosenComicViewModel.error == nil)
            #expect(chosenComicViewModel.state == .loaded)
        }
        
        @Test func testErrorState() async throws {
            let errorViewModel = MyComicViewModel(networking: MockNetworking(result: .failure(.serverError)))
            
            await errorViewModel.getComic(number: 55)

            #expect(errorViewModel.comic == nil)
            #expect(errorViewModel.error == NetworkingError.serverError)
            #expect(errorViewModel.state == .error(NetworkingError.serverError))
        }
        
        @Test(arguments: [99999999, 0, -55])
        func testBadNumbers(_ number: Int) async throws {
            let initialComicViewModel = XkcdHomeViewModel(networking: MockNetworking(result: .success(MockComic.initial)))
            
            await initialComicViewModel.loadInitialComic()
            #expect(initialComicViewModel.state == .loaded)
            
            let isBadNumber = await MainActor.run {
                initialComicViewModel.isBadNumber(input: 55)
            }

            #expect(isBadNumber == true)
        }
    }
    
    @Suite("Comic Date Tests")
    struct ComicDateTests {
        
        @Test func testGoodDateString() async throws {
            let date = ComicDate.create(month: "5", day: "5", year: "2020")
            #expect(date != nil)
            if let date {
                #expect(type(of: date) == Date.self)
            }
        }
        
        @Test func testGoodDateInt() async throws {
            let date = ComicDate.create(month: 5, day: 5, year: 2020)
            #expect(date != nil)
            if let date {
                #expect(type(of: date) == Date.self)
            }
        }
        
        @Test(arguments: [("15", "5", "2020"),
                          ("5", "55", "2020"),
                          ("5", "5", "2050"),
                          ("car", "boat", "plane")])
        func testBadDate(_ date: (month: String, day: String, year: String)) async throws {
            let date = ComicDate.create(month: date.month, day: date.day, year: date.year)
            #expect(date == nil)
        }
    }
}
