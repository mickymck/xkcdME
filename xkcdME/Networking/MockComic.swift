//
//  MockComic.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/8/25.
//

import Foundation

struct MockComic {
    static let initial = Comic(number: 5,
                        title: "INITIAL Comic",
                        imageUrl: "https://imgs.xkcd.com/comics/about_20_pounds.png",
                        month: "10",
                        day: "31",
                        year: "2000")
    
    static let chosen = Comic(number: 55,
                       title: "CHOSEN Comic",
                       imageUrl: "https://imgs.xkcd.com/comics/blownapart_color.jpg",
                       month: "5",
                       day: "5",
                       year: "2020")
}
    
