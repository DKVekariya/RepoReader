//
//  RepoRepository.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 14/05/25.
//

import Foundation

protocol RepoRepository {
    func fetchRepos(page: Int?) async throws -> [Repository]
}

class RepoRepositoryImpl: RepoRepository {

    private let client: APIClient<RepoApi>

    init(client: APIClient<RepoApi>) {
        self.client = client
    }

    func fetchRepos(page: Int? = nil) async throws -> [Repository] {
        return try await client.request(.fetchRepo(page: page))
    }
}

