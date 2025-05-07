//
//  xkcdMETests.swift
//  xkcdMETests
//
//  Created by Micky McKeon on 5/5/25.
//

import Testing
@testable import xkcdME

struct xkcdMETests {
    
    @Suite("View Model Tests")
    struct ViewModelStateChangeTests {
        
        let basicViewModel = MyComicViewModel(networking: Networking.shared)
        
        let initialComic = Comic(num: 5,
                                 title: "INITIAL Comic",
                                 img: "https://imgs.xkcd.com/comics/about_20_pounds.png")
        
        let chosenComic = Comic(num: 55,
                                title: "CHOSEN Comic",
                                img: "https://imgs.xkcd.com/comics/blownapart_color.jpg")
        
        @Test func testOriginalState() async throws {
            #expect(basicViewModel.initialComic == nil)
            #expect(basicViewModel.comic == nil)
            #expect(basicViewModel.errorMessage == nil)
            #expect(basicViewModel.state == .idle)
        }
        
        // TODO: think about combining this and the chosenComic success tests into one with parameters
        @Test func testLoadingInitialComicStates() async throws {
            let initialComicViewModel = MyComicViewModel(networking: MockNetworking(result: .success(initialComic)))
            
            let task = await initialComicViewModel.loadInitialComic()
            #expect(initialComicViewModel.state == .loadingInitial)
            
            await task.value
            #expect(initialComicViewModel.initialComic?.title == initialComic.title)
            #expect(initialComicViewModel.comic == nil)
            #expect(initialComicViewModel.errorMessage == nil)
            #expect(initialComicViewModel.state == .loadedInitial)
        }
        
        @Test func testLoadingChosenComicStates() async throws {
            let chosenComicViewModel = MyComicViewModel(networking: MockNetworking(result: .success(chosenComic)))
            
            let task = await chosenComicViewModel.goToComic(55)
            #expect(chosenComicViewModel.state == .loading)
            
            await task.value
            #expect(chosenComicViewModel.initialComic == nil)
            #expect(chosenComicViewModel.comic?.title == chosenComic.title)
            #expect(chosenComicViewModel.errorMessage == nil)
            #expect(chosenComicViewModel.state == .loaded)
        }
        
        @Test func testErrorState() async throws {
            let errorViewModel = MyComicViewModel(networking: MockNetworking(result: .failure(.serverError)))
            
            let task = await errorViewModel.goToComic(55)
            #expect(errorViewModel.state == .loading)
            
            await task.value
            #expect(errorViewModel.initialComic == nil)
            #expect(errorViewModel.comic == nil)
            #expect(errorViewModel.errorMessage == ComicError.serverError.message)
            #expect(errorViewModel.state == .error)
        }
        
        @Test func testHighNumber() async throws {
            let initialComicViewModel = MyComicViewModel(networking: MockNetworking(result: .success(initialComic)))

            let initialTask = await initialComicViewModel.loadInitialComic()
            await initialTask.value
            let chosenTask = await initialComicViewModel.goToComic(99999999)
            await chosenTask.value
            
            #expect(initialComicViewModel.initialComic?.title == initialComic.title)
            #expect(initialComicViewModel.comic == nil)
            #expect(initialComicViewModel.errorMessage == ComicError.badComicNumber.message)
            #expect(initialComicViewModel.state == .error)
        }
    }
}
