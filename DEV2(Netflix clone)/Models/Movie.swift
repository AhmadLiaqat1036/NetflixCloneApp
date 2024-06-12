//
//  Movie.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/20/24.
//

import Foundation


struct MovieResponse: Codable{
    let results: [Movie]
}
//{"adult":false,"backdrop_path":"/j3Z3XktmWB1VhsS8iXNcrR86PXi.jpg","genre_ids":[878,28,12],"id":823464,"original_language":"en","original_title":"Godzilla x Kong: The New Empire","overview":"Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own.","popularity":7832.06,"poster_path":"/v4uvGFAkKuYfyKLGZnYj6l47ERQ.jpg","release_date":"2024-03-27","title":"Godzilla x Kong: The New Empire","video":false,"vote_average":7.2,"vote_count":1894},
struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let mediaType: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}



/*
 {
adult = 0;
"backdrop_path" = "/9c6YcIUJ1hxoCnoPs3HU4Bgy6Uj.jpg";
"genre_ids" =             (
 16,
 14,
 10751
);
id = 739547;
"media_type" = movie;
"original_language" = en;
"original_title" = "Thelma the Unicorn";
overview = "Thelma dreams of being a glamorous unicorn. Then in a rare pink and glitter-filled moment of fate, Thelma's wish comes true. She rises to instant international stardom, but at an unexpected cost. After a while, Thelma realizes that she was happier as her ordinary, sparkle-free self. So she ditches her horn, scrubs off her sparkles, and returns home, where her best friend is waiting for her with a hug.";
popularity = "174.219";
"poster_path" = "/yutiEZ7taGDNau2jGjKIdDwQpDw.jpg";
"release_date" = "2024-05-17";
title = "Thelma the Unicorn";
video = 0;
"vote_average" = "6.789";
"vote_count" = 38;
},
 */
