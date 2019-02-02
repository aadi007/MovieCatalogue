//
//  MovieListViewModel.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper
final class MovieListViewModel {
    var maxYear = 2019
    var minYear = 2019
    var imageConfig: ImageConfiguration?
    private var queryArray = [String]()
    private var networkResource: NetworkProvider<NetworkRouter> = AppProvider.networkManager
    private var page = 0
    private var queryIndex = 0
    private var totalPages = -1
    var movies = [Movie]()
    init(networkProvider: NetworkProvider<NetworkRouter>) {
        self.networkResource = networkProvider
        fillQueryDetails()
    }
    func fillQueryDetails() {
        let diff = maxYear - minYear
        for i in 0..<diff + 1 {
            queryArray.append((minYear + i).description)
        }
    }
    func setfilterQuery(minyear: Int, maxYear: Int) {
        self.minYear = minyear
        self.maxYear = maxYear
        queryArray.removeAll()
        self.fillQueryDetails()
        page = 0
        queryIndex = 0
        totalPages = -1
        movies.removeAll()
    }
    func fetchConfig(completionHandler: @escaping ((_ errorMessage: String?) -> Void)) {
        networkResource.request(NetworkRouter.getConfig) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    do {
                        if let data = try moyaResponse.mapJSON() as? [String: Any] {
                            if let apiResponse = Mapper<ImageConfiApiResponse>().map(JSONObject: data), let imageConfig = apiResponse.imageConfig {
                                self.imageConfig = imageConfig
                            }
                            completionHandler(nil)
                        }
                    } catch {
                        print(moyaResponse.data)
                        completionHandler("Failed to parse the json response")
                    }
                } else {
                    print(statusCode)
                    completionHandler("Failed with statusCode \(statusCode)")
                }
            case let .failure(error):
                print("error \(error.errorDescription ?? "")")
                completionHandler(error.errorDescription)
            }
        }
    }
    func fetchMovies(completionHandler: @escaping ((_ errorMessage: String?) -> Void)) {
        if isLastPage() {
            queryIndex += 1
            if queryIndex == queryArray.count {
                return
            }
            //logic to rest the pages and paginated data
            page = 0
            totalPages = -1
        }
        page += 1
        let currentYear = queryArray[queryIndex]
        networkResource.request(NetworkRouter.searchMovies(page: page, query: currentYear)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    do {
                        if let data = try moyaResponse.mapJSON() as? [String: Any] {
                            if let paginatedResponse = Mapper<MoviesPaginatedApiResponse>().map(JSONObject: data),
                                let _ = paginatedResponse.results  {
                                self.totalPages = paginatedResponse.totalPages
                                self.movies += paginatedResponse.getFilteredMovieFor(year: currentYear)
                            }
                            print(data)
                            completionHandler(nil)
                        }
                    } catch {
                        print(moyaResponse.data)
                        completionHandler("Failed to parse the json response")
                    }
                } else {
                    print(statusCode)
                    completionHandler("Failed with statusCode \(statusCode)")
                }
            case let .failure(error):
                print("error \(error.errorDescription ?? "")")
                completionHandler(error.errorDescription)
            }
        }
    }
    func isLastPage() -> Bool {
        if totalPages == page {
            return true
        } else {
            return false
        }
    }
}
