//
//  ContentView.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import SwiftUI

struct MyComicView: View {
    @State private var comicNumber: Int = 600
    private var viewModel: MyComicViewModel = MyComicViewModel()
    
    var body: some View {
        VStack {
            Text("xkcd")
            Button("Fetch Comic") {
                // TODO: Fetch the comic - need VM and @State wrapped textfield
                Task {
                    await viewModel.load(comic: comicNumber)
                }
            }
            if let myComic = viewModel.comic {
                Text(myComic.title)
                    .font(.title)
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    MyComicView()
}
