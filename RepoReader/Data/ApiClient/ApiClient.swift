//
//  ApiClient.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 14/05/25.
//

import Foundation
import Alamofire
import Combine

protocol Routable: URLRequestConvertible {
    var task: APITask { get }
}

class APIClient<Router: Routable> {

    private let session: Session

    init(session: Session) {
        self.session = session
    }

    func request<T: Decodable>(_ route: Router) async throws -> T {
        switch route.task {
        case .dataTask:
            try await withCheckedThrowingContinuation { continuation in
                AF.request(route)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let data):
                            continuation.resume(returning: data)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
            }
        }
    }
}

enum APITask {
    case dataTask
}
