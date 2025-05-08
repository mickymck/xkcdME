//
//  ContentView.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import SwiftUI

struct XkcdMe: View {
    @State private var comicNumber: Int?
    @State private var showComic: Bool = false
    @StateObject private var viewModel = XkcdMeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                header()
                Divider()
                if let comic = viewModel.comic {
                    ComicView(myComic: comic)
                }
                Spacer()
                searchSection()
                .navigationDestination(isPresented: $showComic) {
                    if let comicNumber {
                        MyComicView(number: comicNumber)
                    }
                }
                .navigationTitle("xkcd me")
                .navigationBarHidden(true)
            }
            .padding(24)
            .onAppear {
                self.comicNumber = nil
                Task {
                    _ = await viewModel.loadInitialComic()
                }
            }
        }
    }
    
    @ViewBuilder
    private func header() -> some View {
        let subtitle =
"""
A webcomic of romance,
sarcasm, math, and language.
"""
        HStack {
            Text("xkcd")
                .font(Font.custom("American Typewriter", size: 48))
                .fontWeight(.medium)
                .foregroundColor(.purple)
                .padding(.trailing, 8)
            Text(subtitle)
                .font(.subheadline)
        }
    }
    
//    @ViewBuilder
//    private func mainContentView() -> some View {
//        switch viewModel.state {
//        case .loaded:
//            if let comic = viewModel.comic {
//                ComicView(myComic: comic)
//            }
//        case .error(let error):
//            Text(error.message)
//                .font(.body)
//                .foregroundColor(.red)
//        case .loading:
//            ProgressView()
//                .scaleEffect(2.0, anchor: .center)
//        case .idle:
//            EmptyView()
//        }
//    }
    
    @ViewBuilder
    private func searchSection() -> some View {
        var placeholderText: String {
            if let latest = viewModel.comic?.number {
                return "Comic # 1 - \(latest)"
            }
            return "Comic #"
        }
        VStack(alignment: .leading) {
            if let error = viewModel.userInputError {
                VStack {
                    Text(error.message)
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
            
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let buttonWidth = totalWidth / 3
                let textFieldWidth = totalWidth - buttonWidth
                let sharedHeight: CGFloat = 40
                
                HStack(spacing: 8) {
                    TextField(placeholderText,
                              value: $comicNumber,
                              formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: textFieldWidth, height: sharedHeight)
                    .accessibilityHint("Number of the comic to fetch")
                    
                    Button {
                        checkNumberAndGoToComic()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                            Text("xkcd me")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .accessibilityLabel("Fetch comic")
                        .frame(width: buttonWidth, height: sharedHeight)
                }
            }
            .frame(height: 40)
        }
    }
    
    private func checkNumberAndGoToComic() {
        if let comicNumber {
            if viewModel.isBadNumber(input: comicNumber) == true {
                viewModel.userInputError = .badComicNumber
            } else {
                viewModel.userInputError = nil
                self.showComic = true
            }
        }
    }
}

#Preview {
    XkcdMe()
}
