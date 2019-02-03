//
//  NetworkManager.swift
//  DisplayData
//
//  Created by Aadesh Maheshwari on 2/1/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import Moya
import Alamofire
let API_KEY = "a0332783bce8a7c77ad0c76a4071c1a1"

public typealias NetworkProvider = MoyaProvider
enum NetworkRouter {
    case getConfig(apiKey: String)
    case searchMovies(apiKey: String, page: Int, query: String)
    case getMovieDetails(apiKey: String, id: Double)
}
extension NetworkRouter: TargetType {
    var baseURL: URL { return URL(string: "https://api.themoviedb.org/3/")! }
    var path: String {
        switch self {
        case .getConfig:
            return "configuration"
        case .searchMovies:
            return "search/movie"
        case .getMovieDetails(_, let id):
            return "movie/\(id)"
        }
    }
    var method: Moya.Method {
        switch self {
        case .searchMovies,
            .getConfig,
            .getMovieDetails:
            return .get
        }
    }
    var task: Task {
        switch self {
        case let .getConfig(apiKey),
            let .getMovieDetails(apiKey, _):
            return .requestParameters(parameters: ["api_key": apiKey], encoding: URLEncoding.queryString)
        case let .searchMovies(apiKey, page, query):
            return .requestParameters(parameters: ["api_key": apiKey, "page": page, "query": query], encoding: URLEncoding.queryString)
        }
    }
    var sampleData: Data {
        switch self {
        case .getConfig:
            return StubResponse.fromJSONFile("MoviesConfiguration")
        case .searchMovies:
            return StubResponse.fromJSONFile("SearchMovies")
        case .getMovieDetails:
            return StubResponse.fromJSONFile("MovieDetail")
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
struct AppProvider {
    static let networkManager: NetworkProvider<NetworkRouter> = {
        return MoyaProvider<NetworkRouter>(endpointClosure: networkEndPointClousure, manager: DefaultAlamofireManager.sharedManager)
    }()
}
var networkEndPointClousure = { (target: NetworkRouter) -> Endpoint in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    return Endpoint(url: url, sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers)
}
class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy = .useProtocolCachePolicy
        let instance = DefaultAlamofireManager (
            configuration: configuration
        )
        return instance
    }()
}
final class StubResponse {
    static func fromJSONFile(_ fileName: String) -> Data {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("Invalid path for json file")
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Invalid data from json file")
        }
        return data
    }
    static func fromJSONFile(_ fileName: String) -> String {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("Invalid path for txt file")
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Invalid data from txt file")
        }
        let str = String(data: data, encoding: String.Encoding.utf8)!
        return str
    }
}
