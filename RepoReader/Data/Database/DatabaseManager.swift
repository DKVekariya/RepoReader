//
//  RepositoryDatabase.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 14/05/25.
//

import Foundation
import SwiftData

protocol DatabaseManager {
    func insertRepository(_ repository: Repository)
    func insertRepositories(_ repositories: [Repository])

    func fetchAllRepositories() -> [Repository]
    func fetchBookmarkedRepositories() -> [Repository]
    func fetchRepository(byId id: Int) -> Repository?

    func updateRepository(_ model: Repository, with repository: Repository)
    func toggleBookmark(forRepositoryId id: Int, isBookmarked: Bool)

    func deleteRepository(byId id: Int)
    func deleteAllRepositories()

    func repositoryExists(id: Int) -> Bool
}

class DatabaseManagerImpl: DatabaseManager {
    private let context: ModelContext?

    init(context: ModelContext?) {
        self.context = context
    }

    // MARK: - Create

    func insertRepository(_ repository: Repository) {
        guard !repositoryExists(id: repository.id) else { return }

        let newRepo = Repository(
            id: repository.id,
            name: repository.name,
            description: repository.repoDescription,
            stargazersCount: repository.stargazersCount,
            language: repository.language,
            htmlUrl: repository.htmlUrl,
            updatedAt: repository.updatedAt,
            isBookmarked: repository.isBookmarked
        )
        context?.insert(newRepo)
        try? context?.save()
    }

    func insertRepositories(_ repositories: [Repository]) {
        for repository in repositories {
            insertRepository(repository)
        }
    }

    // MARK: - Read

    func fetchAllRepositories() -> [Repository] {
        let descriptor = FetchDescriptor<Repository>(
            sortBy: [SortDescriptor(\.stargazersCount, order: .reverse)]
        )
        return (try? context?.fetch(descriptor)) ?? []
    }

    func fetchBookmarkedRepositories() -> [Repository] {
        let descriptor = FetchDescriptor<Repository>(
            predicate: #Predicate { $0.isBookmarked == true }
        )
        return (try? context?.fetch(descriptor)) ?? []
    }

    func fetchRepository(byId id: Int) -> Repository? {
        let descriptor = FetchDescriptor<Repository>(
            predicate: #Predicate { $0.id == id }
        )
        return try? context?.fetch(descriptor).first
    }

    // MARK: - Update

    func updateRepository(_ model: Repository, with repository: Repository) {
        model.name = repository.name
        model.repoDescription = repository.repoDescription
        model.language = repository.language
        model.htmlUrl = repository.htmlUrl
        model.stargazersCount = repository.stargazersCount
        model.updatedAt = repository.updatedAt
        model.isBookmarked = repository.isBookmarked
        try? context?.save()
    }

    func toggleBookmark(forRepositoryId id: Int, isBookmarked: Bool) {
        guard let model = fetchRepository(byId: id) else { return }
        model.isBookmarked = isBookmarked
        try? context?.save()
    }

    // MARK: - Delete

    func deleteRepository(byId id: Int) {
        guard let model = fetchRepository(byId: id) else { return }
        context?.delete(model)
        try? context?.save()
    }

    func deleteAllRepositories() {
        let descriptor = FetchDescriptor<Repository>()
        if let all = try? context?.fetch(descriptor) {
            all.forEach { context?.delete($0) }
            try? context?.save()
        }
    }

    // MARK: - Helper

    func repositoryExists(id: Int) -> Bool {
        fetchRepository(byId: id) != nil
    }
}
