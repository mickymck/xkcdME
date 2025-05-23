//
//  XkcdHomeView.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import SwiftUI

struct XkcdHomeView: View {
    @State private var comicNumber: Int?
    @State private var showChosenComic: Bool = false
    @StateObject private var viewModel: XkcdHomeViewModel
    
    init(networking: ComicFetching = Networking.shared) {
        _viewModel = StateObject(wrappedValue: XkcdHomeViewModel(networking: networking))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                header()
                Divider()
                mainContentView()
                Spacer()
                searchSection()
                .navigationDestination(isPresented: $showChosenComic) {
                    if let comicNumber {
                        MyComicView(number: comicNumber)
                    }
                }
                .navigationTitle("xkcd me")
                .navigationBarHidden(true)
            }
            .padding()
            .onAppear {
                self.comicNumber = nil
                Task {
                    await viewModel.loadInitialComic()
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
    
    @ViewBuilder
    private func mainContentView() -> some View {
        VStack {
            switch viewModel.state {
            case .loaded:
                if let comic = viewModel.comic {
                    ComicView(myComic: comic)
                }
            case .error(let error):
                Text(error.message)
                    .font(.body)
                    .foregroundColor(.red)
            case .loading:
                ProgressView()
                    .scaleEffect(2.0, anchor: .center)
            case .idle:
                EmptyView()
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func searchSection() -> some View {
        var placeholderText: String {
            if let latest = viewModel.comic?.number {
                return "Comic # 1 - \(latest)"
            }
            return "Comic #"
        }
        VStack(alignment: .leading) {
            if let error = viewModel.error {
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
        .padding()
    }
    
    private func checkNumberAndGoToComic() {
        if let comicNumber {
            if viewModel.isBadNumber(input: comicNumber) == true {
                viewModel.error = .badComicNumber
            } else {
                viewModel.error = nil
                self.showChosenComic = true
            }
        }
    }
}

#Preview {
    XkcdHomeView(networking: MockNetworking(result: .success(MockComic.initial)))
}
