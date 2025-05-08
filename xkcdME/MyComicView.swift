//
//  MyComicView.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/6/25.
//

import SwiftUI

struct MyComicView: View {
    let number: Int
    let viewModel = MyComicViewModel()

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
            _ = await viewModel.getComic(number: number)
        }
    }
}

#Preview {
    MyComicView(number: 15)
}
