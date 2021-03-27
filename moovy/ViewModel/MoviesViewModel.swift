//
//  MoviesViewModel.swift
//  moovy
//
//  Created by fârûqî on 25.03.2021.
//

import Foundation

struct MovieViewModel {
    
   // let adult: Bool?
   // let backdrop_path: String?
   // let budget: Int?
   // let genres: [Genre]?
   // let homepage: String?
    let id: Int?
    let imdb_url: String?
   // let original_language: String?
   // let original_title: String?
    let overview: String?
   // let popularity: Float?
    let poster_url: URL?
   // let production_companies: [Company]?
   // let production_countries: [Country]?
    let release_date: String?
   // let revenue: Int?
   // let runtime: Int?
   // let spoken_languages: [Language]?
   // let status: String?
   // let tagline: String?
    let title: String?
   // let video: Bool?
    let vote_average: String?
   // let vode_count: Int?
    let year: String?
    
    init(movie: Movie) {
        let file_path = "https://image.tmdb.org/t/p/w500/"
        let defaultImg = Bundle.main.url(forResource: "tmdb", withExtension: "png")
        let yr = movie.release_date?.prefix(4).description
        
        self.title = movie.title
        self.poster_url = movie.poster_path != nil ? URL(string: file_path + (movie.poster_path ?? "")): defaultImg
        self.overview = movie.overview
        self.vote_average = "⭐ \( movie.vote_average ?? 0)"
        self.release_date = movie.release_date
        self.id = movie.id
        self.imdb_url = "https://www.imdb.com/title/\(movie.imdb_id ?? "")"
        self.year = "(\(yr ?? ""))"
    }
    
    
}

struct SearchedMoviesViewModel {
    let title: String
    
    init(movie: Movie) {
        self.title = movie.title ?? ""
    }
}
