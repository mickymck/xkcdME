//
//  Comic.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import Foundation

class Comic: Codable {
    let num: Int
    let title: String
    let img: String
    
    init(num: Int, title: String, img: String) {
        self.num = num
        self.title = title
        self.img = img
    }
}
