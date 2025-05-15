//
//  AppHost.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 14/05/25.
//

import Foundation
enum AppHost {

    /// Set HostKind according to app environment Ex: live, debug
    static let currentHostKind: Kind = isDevMode() ? .dev : .live

    static public func isDevMode() -> Bool {
        // handle the dev mode here
        return true
    }
}

extension AppHost {
    enum Kind {
        case live, dev
    }

    static var baseURL: URL {
        switch currentHostKind {
        case .live:
            return URL(string: "https://api.github.com")!
        case .dev:
            return URL(string: "https://api.github.com")!
        }
    }
}

