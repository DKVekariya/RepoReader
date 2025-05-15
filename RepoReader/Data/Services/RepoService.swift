//
//  RepoService.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 14/05/25.
//

import Foundation
import Alamofire

private enum RepoApiKey: String {
    case page
}

public enum RepoApi {
    case fetchRepo(page: Int? = nil)

}

extension RepoApi {

    private var parameters: (ParameterType, ParameterEncoding)? {
        switch self {
        case .fetchRepo(let page):
            guard let page else { return nil }
            return (.jsonDic([RepoApiKey.page.rawValue: page]), URLEncoding.queryString)
        }
    }

    private var path: String {
        switch self {
        case .fetchRepo:
            return "/orgs/square/repos"
        }
    }

    private var method: HTTPMethod {
        switch self {
        case .fetchRepo:
            return .get
        }
    }

    private var headers: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
}

extension RepoApi: Routable {
    var task: APITask {
        switch self {
        case .fetchRepo:
            return .dataTask
        }
    }

    public func asURLRequest() throws -> URLRequest {
        let url: URL = path.isEmpty ? AppHost.baseURL : AppHost.baseURL.appendingPathComponent(path)
        let method = self.method
        let headers = HTTPHeaders(self.headers ?? [:])
        var request = try URLRequest(url: url, method: method, headers: headers)

        if let (parameterkind, encoding) = self.parameters {
            request = try request.encoded(parameterKind: parameterkind, parameterEncoding: encoding)
        }
        return request
    }
}
