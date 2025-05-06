//
//  ContentView.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import SwiftUI

struct MyComicView: View {
    @State private var comicNumber: Int?
    @ObservedObject private var viewModel: MyComicViewModel = MyComicViewModel()
    
    var body: some View {
        VStack {
            if let myComic = viewModel.comic {
                AsyncImage(url: URL(string: myComic.img)) { phase in
                    switch phase {
                    case .empty:
                        // TODO: better to determine state in VM rather than based on AsyncImage phase?
                        ProgressView()
                            .scaleEffect(2.0, anchor: .center)
                    case .success(let image):
                        comicView(title: myComic.title, image: image)
                    case .failure(let error):
                        Text("Error loading Comic: \(error.localizedDescription)")
                    @unknown default:
                        Text("Error loading Comic")
                    }
                }
            }
            Spacer()
            TextField("Comic Number", value: $comicNumber, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .submitLabel(.go)
                .onSubmit {
                    Task {
                        guard let number = comicNumber else { return }
                        await viewModel.load(comic: number)
                    }
                }
        }
        .padding(24)
    }
    
    @ViewBuilder
    private func comicView(title: String, image: Image) -> some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.largeTitle)
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MyComicView()
}
