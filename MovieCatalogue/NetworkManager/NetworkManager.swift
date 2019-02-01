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
    case getPopularMovies(page: Int)
    case getData(resourceId: String, limit: Int, query: String)
}
extension NetworkRouter: TargetType {
    var baseURL: URL { return URL(string: "https://data.gov.sg/api/action/")! }
    var path: String {
        switch self {
        case .getPopularMovies:
            return "movie/popular"
        case .getData:
            return "datastore_search"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getData, .getPopularMovies:
            return .get
        }
    }
    var task: Task {
        switch self {
        case let .getData(resourceId, limit, query):  // Always sends parameters in URL, regardless of which HTTP method is used
            return .requestParameters(parameters: ["resource_id": resourceId, "limit": limit, "q": query], encoding: URLEncoding.queryString)
        case let .getPopularMovies(page):
            return .requestParameters(parameters: ["api_key": API_KEY, "page": page], encoding: URLEncoding.queryString)
        }
    }
    var sampleData: Data {
        switch self {
        case .getData:
            return StubResponse.fromJSONFile("RecordResponse")
        case .getPopularMovies:
            return StubResponse.fromJSONFile("PopularMovies")
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
