//
//  model.swift
//  moovy
//
//  Created by fârûqî on 25.03.2021.
//

import Foundation

struct Movie: Codable {
    let adult: Bool?
    let backdrop_path: String?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdb_id: String?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Float?
    let poster_path: String?
    let production_companies: [Company]?
    let production_countries: [Country]?
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let spoken_languages: [Language]?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let vote_average: Float?
    let vode_count: Int?
}

struct MovieBundle: Codable {
    let dates: Dates?
    let page: Int?
    let results: [Movie]
    let total_pages: Int?
    let total_results: Int?
}

struct Dates: Codable {
    let maximum: String?
    let minimum: String?
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}

struct Company: Codable {
    let id: Int?
    let logo_path: String?
    let name: String?
    let origin_country: String?
}

struct Country: Codable {
    let iso_3166_1: String?
    let name: String?
}

struct Language: Codable {
    let english_name: String?
    let iso_639_1: String?
    let name: String?
}
