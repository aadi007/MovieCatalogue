//
//  MovieDetail.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper
class MovieDetail: Mappable {
    var id: Double = 0
    var title: String?
    var overView: String?
    var releaseDate: String?
    var popularity: Double = 0
    var voteAverage: Double = 0
    var voteCount: Double = 0
    var adult = false
    var posterPath: String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        id                      <- map["id"]
        title                    <- map["title"]
        overView                 <- map["overview"]
        releaseDate               <- map["release_date"]
        popularity                <- map["popularity"]
        voteAverage               <- map["vote_average"]
        voteCount                 <- map["vote_count"]
        adult                    <- map["adult"]
        posterPath                <- map["poster_path"]
    }
    func getMoviewDetailArray() -> [Any] {
        var detailsArray = [Any]()
        detailsArray.append(posterPath ?? "")
        detailsArray.append(title ?? "")
        detailsArray.append(overView ?? "")
        detailsArray.append(releaseDate ?? "")
        detailsArray.append(popularity)
        detailsArray.append(voteAverage)
        detailsArray.append(voteCount)
        detailsArray.append(adult)
        return detailsArray
    }
}
