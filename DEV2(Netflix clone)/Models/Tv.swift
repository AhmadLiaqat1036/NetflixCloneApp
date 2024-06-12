//
//  Tv.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/20/24.
//

import Foundation


struct TvResponse:Codable{
    let results: [Tv]
}

struct Tv: Codable {
    let adult: Bool
    let backdropPath: String?
    let firstAirDate: String
    let genreIds: [Int]
    let id: Int
    let mediaType: String?
    let name: String
    let originCountry: [String]
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIds = "genre_ids"
        case id
        case mediaType = "media_type"
        case name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
