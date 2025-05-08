//
//  MyComicView.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/6/25.
//

import SwiftUI

struct MyComicView: View {

    @StateObject private var viewModel: MyComicViewModel
    let number: Int
    
    init(number: Int, networking: ComicFetching = Networking.shared) {
        _viewModel = StateObject(wrappedValue: MyComicViewModel(networking: networking))
        self.number = number
    }

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loaded:
                if let comic = viewModel.comic {
                    ComicView(myComic: comic)
                }
            case .error:
            if let networkingError = viewModel.error {
                Text(networkingError.message)
                    .font(.body)
                    .foregroundColor(.red)
            }
            case .loading:
                ProgressView()
                    .scaleEffect(2.0, anchor: .center)
            case .idle:
                EmptyView()
            }
        }
        .padding()
        .task {
            await viewModel.getComic(number: number)
        }
    }
}

#Preview {
    MyComicView(number: 15, networking: MockNetworking(result: .success(MockComic.chosen)))
}
