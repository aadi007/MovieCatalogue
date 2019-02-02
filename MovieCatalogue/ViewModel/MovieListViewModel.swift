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
    var maxYear = 2018
    var minYear = 2018
    var imageConfig: ImageConfiguration?
    private var queryArray = [String]()
    private var networkResource: NetworkProvider<NetworkRouter> = AppProvider.networkManager
    private var page = 1
    private var queryIndex = 0
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
        let currentYear = queryArray[queryIndex]
        networkResource.request(NetworkRouter.searchMovies(page: page, query: currentYear)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    do {
                        if let data = try moyaResponse.mapJSON() as? [String: Any] {
                            if let apiResponse = Mapper<MoviesPaginatedApiResponse>().map(JSONObject: data),
                                let movies = apiResponse.results  {
                                self.movies += movies
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
}
