//
//  Comic.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/5/25.
//

import Foundation

class Comic: Decodable {
    let number: Int
    let title: String
    let imageUrl: String
    let date: Date?
    
    enum CodingKeys: String, CodingKey {
        case number = "num"
        case title
        case imageUrl = "img"
        case month
        case day
        case year
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decode(Int.self, forKey: .number)
        title = try container.decode(String.self, forKey: .title)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        
        let month = try container.decode(String.self, forKey: .month)
        let day = try container.decode(String.self, forKey: .day)
        let year = try container.decode(String.self, forKey: .year)
        self.date = ComicDate.create(month: month, day: day, year: year)
    }
    
    init(number: Int, title: String, imageUrl: String, month: String, day: String, year: String) {
        self.number = number
        self.title = title
        self.imageUrl = imageUrl
        self.date = ComicDate.create(month: month, day: day, year: year)
    }
}
