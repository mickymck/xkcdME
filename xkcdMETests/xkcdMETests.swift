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
        
        let initialComic = Comic(number: 5,
                                 title: "INITIAL Comic",
                                 imageUrl: "https://imgs.xkcd.com/comics/about_20_pounds.png",
                                 month: "10",
                                 day: "31",
                                 year: "2000")
        
        let chosenComic = Comic(number: 55,
                                title: "CHOSEN Comic",
                                imageUrl: "https://imgs.xkcd.com/comics/blownapart_color.jpg",
                                month: "5",
                                day: "5",
                                year: "2020")
        
        @Test func testOriginalState() async throws {
            #expect(xkcdHomeViewModel.comic == nil)
            #expect(xkcdHomeViewModel.state == .idle)
        }
        
        // TODO: think about combining this and the chosenComic success tests into one with parameters
        @Test func testLoadingInitialComicStates() async throws {
            let initialComicViewModel = XkcdHomeViewModel(networking: MockNetworking(result: .success(initialComic)))
            
            let task = await initialComicViewModel.loadInitialComic()
            #expect(initialComicViewModel.state == .loading)
            
            await task.value
            #expect(initialComicViewModel.comic?.title == initialComic.title)
            #expect(initialComicViewModel.userInputError == nil)
            #expect(initialComicViewModel.state == .loaded)
        }
        
        @Test func testLoadingChosenComicStates() async throws {
            let chosenComicViewModel = MyComicViewModel(networking: MockNetworking(result: .success(chosenComic)))
            
            let task = await chosenComicViewModel.getComic(number: 55)
            #expect(chosenComicViewModel.state == .loading)
            
            await task.value
            #expect(chosenComicViewModel.comic?.title == chosenComic.title)
            #expect(chosenComicViewModel.error == nil)
            #expect(chosenComicViewModel.state == .loaded)
        }
        
        @Test func testErrorState() async throws {
            let errorViewModel = MyComicViewModel(networking: MockNetworking(result: .failure(.serverError)))
            
            let task = await errorViewModel.getComic(number: 55)
            #expect(errorViewModel.state == .loading)
            
            await task.value
            #expect(errorViewModel.comic == nil)
            #expect(errorViewModel.error == NetworkingError.serverError)
            #expect(errorViewModel.state == .error(NetworkingError.serverError))
        }
        
        @Test(arguments: [99999999, 0, -55])
        func testBadNumbers(_ number: Int) async throws {
            let initialComicViewModel = XkcdHomeViewModel(networking: MockNetworking(result: .success(initialComic)))

            let initialTask = await initialComicViewModel.loadInitialComic()
            await initialTask.value
            let isBadNumber = initialComicViewModel.isBadNumber(input: number)
            
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
