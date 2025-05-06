//
//  ContentView.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import SwiftUI

struct XkcdMe: View {
    @State private var comicNumber: Int?
    @State private var showComic: Bool = false {
        didSet {
            print("isPresented: \(showComic)")
        }
    }
    @StateObject private var viewModel: MyComicViewModel = MyComicViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                header()
                Spacer()
                initialComic()
                Spacer()
                searchSection()
                .navigationDestination(isPresented: $showComic) {
                    if let myComic = viewModel.comic {
                        MyComicView(myComic: myComic)
                    }
                }
                .padding(24)
            }
        }
        .onChange(of: viewModel.state, { _, newValue in
            showComic = newValue == .loaded
        })
    }
    
    @ViewBuilder
    private func header() -> some View {
        let subtitle =
"""
A webcomic of romance,
sarcasm, math, and language.
"""
        VStack {
            Text("xkcd")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text(subtitle)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private func initialComic() -> some View {
        if let myComic = viewModel.currentComic {
            MyComicView(myComic: myComic)
        } else {
            ProgressView()
                .scaleEffect(2.0, anchor: .center)
                .task {
                    await viewModel.loadInitialComic()
                }
        }
    }
        
    
    @ViewBuilder
    private func searchSection() -> some View {
        HStack {
            TextField("Comic Number", value: $comicNumber, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: 200, height: 32)
            goButton()
        }
    }
        
    
    @ViewBuilder
    private func goButton() -> some View {
        Button {
            Task {
                guard let number = comicNumber else { return }
                await viewModel.goToComic(number)
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
                    .frame(width: 100, height: 32)
                Text("xkcd me")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    XkcdMe()
}
