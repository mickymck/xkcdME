//
//  MyComicView.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/6/25.
//

import SwiftUI

struct MyComicView: View {
    let myComic: Comic

    var body: some View {
        VStack {
            ComicView(myComic: myComic)
        }
        .padding()
    }
}

#Preview {
    MyComicView(
        myComic: Comic(
            num: 1,
            title: "Test Title",
            img: "https://imgs.xkcd.com/comics/unstoppable_force_and_immovable_object.png"
        )
    )
}
