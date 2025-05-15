//
//  AppError.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 14/05/25.
//

import Foundation
import Alamofire

enum AppError: Error {
    case networkError(Error)
    case decodingError(Error)
    case unknownError
    case invalidResponse
    case invalidURL
    case serverError(Error)

    init(error: Error) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .badURL, .unsupportedURL:
                self = .invalidURL
            case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                self = .networkError(urlError)
            case .badServerResponse, .httpTooManyRedirects:
                self = .serverError(urlError)
            default:
                self = .unknownError
            }
        } else if error is DecodingError {
            self = .decodingError(error)
        } else {
            self = .unknownError
        }
    }

    var message: String {
        switch self {
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        case .invalidResponse:
            return "The server response was invalid."
        case .invalidURL:
            return "The request URL was invalid."
        case .serverError(let error):
            return "Server error: \(error.localizedDescription)"
        }
    }
}
