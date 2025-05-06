//
//  ComicView.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/6/25.
//

import SwiftUI

struct ComicView: View {
    let myComic: Comic
    var body: some View {
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
    
    @ViewBuilder
    private func comicView(title: String, image: Image) -> some View {
        ZStack {
            VStack {
                Text(title)
                    .font(.largeTitle)
                Spacer()
            }
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ComicView(
        myComic: Comic(
            num: 1,
            title: "Test Title",
            img: "https://imgs.xkcd.com/comics/unstoppable_force_and_immovable_object.png"
        )
    )
}
