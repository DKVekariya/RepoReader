//
//  URLRequest+Extension.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 14/05/25.
//

import Foundation
import Alamofire

public enum ParameterType {
    case jsonDic([String: Any])
    case encodable(Encodable)
}

public struct AnyEncodable: Encodable {

    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    public func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

extension URLRequest {

    public mutating func encoded(parameterKind: ParameterType, parameterEncoding: ParameterEncoding, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        switch parameterKind {
        case .encodable(let encodable):
            do {
                let encodable = AnyEncodable(encodable)
                httpBody = try encoder.encode(encodable)

                let contentTypeHeaderName = "Content-Type"
                if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                    setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
                }
                return self
            } catch {
                throw error
            }

        case .jsonDic(let parameters):
            do {
                return try parameterEncoding.encode(self, with: parameters)
            } catch {
                throw error
            }
        }
    }
}
