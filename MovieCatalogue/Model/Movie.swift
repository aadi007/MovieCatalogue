//
//  Movie.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper
class Movie: Mappable {
    var id: Double = 0
    var votesCount: Double = 0
    var voteAverage: Double = 0
    var title: String?
    var posterPath: String?
    var adult = false
    var overView: String?
    var releaseDate: String?
    var popularity: Double = 0
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        id             <- map["id"]
        votesCount       <- map["vote_count"]
        voteAverage      <- map["vote_average"]
        title           <- map["title"]
        posterPath       <- map["poster_path"]
        adult           <- map["adult"]
        overView        <- map["overview"]
        releaseDate      <- map["release_date"]
        popularity       <- map["popularity"]
    }
}

class MoviesPaginatedApiResponse: Mappable {
    var totalResults: Double = 0
    var totalPages = 0
    var results: [Movie]?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        totalResults             <- map["total_results"]
        totalPages               <- map["total_pages"]
        results                  <- map["results"]
    }
    func getFilteredMovieFor(year: String) -> [Movie] {
        if let movies = results {
            return movies.filter({ $0.releaseDate?.contains(year) ?? false })
        } else {
            return [Movie]()
        }
    }
 }
