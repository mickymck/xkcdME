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
        VStack {
            AsyncImage(url: URL(string: myComic.imageUrl)) { phase in
                switch phase {
                case .empty:
                    // TODO: better to determine state in VM rather than based on AsyncImage phase?
                    ProgressView()
                        .scaleEffect(2.0, anchor: .center)
                case .success(let image):
                    comicView(title: myComic.title, date: myComic.date, image: image)
                case .failure(let error):
                    Text("Error loading Comic: \(error.localizedDescription)")
                @unknown default:
                    Text("Error loading Comic")
                }
            }
        }
        .frame(maxHeight: .infinity)
        .accessibilityLabel("Comic image")
    }
    
    @ViewBuilder
    private func comicView(title: String, date: Date?, image: Image) -> some View {
        VStack {
            VStack {
                Text(title)
                    .font(.largeTitle)
                if let date {
                    Text(date.formatted(date: .long, time: .omitted))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 32)
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding(.top, 32)
    }
}

#Preview {
    ComicView(
        myComic: Comic(
            number: 1,
            title: "Test Title",
            imageUrl: "https://imgs.xkcd.com/comics/unstoppable_force_and_immovable_object.png",
            month: "6",
            day: "23",
            year: "2015"
        )
    )
}
