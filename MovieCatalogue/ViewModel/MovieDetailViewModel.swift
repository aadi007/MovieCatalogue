//
//  MovieDetailViewModel.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper

class MovieDetailViewModel: NSObject {
    private var networkResource: NetworkProvider<NetworkRouter> = AppProvider.networkManager
    var movieDetail = [Any]()
    init(networkProvider: NetworkProvider<NetworkRouter>) {
        self.networkResource = networkProvider
    }
    
    func fetchMovieDetails(id: Double, completionHandler: @escaping ((_ errorMessage: String?) -> Void)) {
        networkResource.request(NetworkRouter.getMovieDetails(id: id)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    do {
                        if let data = try moyaResponse.mapJSON() as? [String: Any] {
                            if let movieDetail = Mapper<MovieDetail>().map(JSONObject: data) {
                                self.movieDetail = movieDetail.getMoviewDetailArray()
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
