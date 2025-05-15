//
//  Repository.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 14/05/25.
//

import Foundation
import SwiftData

@Model
class Repository: Codable, @unchecked Sendable {
    @Attribute(.unique) var id: Int
    var name: String
    var repoDescription: String?
    var stargazersCount: Int
    var language: String?
    var htmlUrl: String
    var updatedAt: String
    var isBookmarked: Bool

    // MARK: - Init

    init(
        id: Int,
        name: String,
        description: String?,
        stargazersCount: Int,
        language: String?,
        htmlUrl: String,
        updatedAt: String,
        isBookmarked: Bool = false
    ) {
        self.id = id
        self.name = name
        self.repoDescription = description
        self.stargazersCount = stargazersCount
        self.language = language
        self.htmlUrl = htmlUrl
        self.updatedAt = updatedAt
        self.isBookmarked = isBookmarked
    }

    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, name
        case repoDescription = "description"
        case stargazersCount = "stargazers_count"
        case language
        case htmlUrl = "html_url"
        case updatedAt = "updated_at"
        case isBookmarked = "is_bookmarked"
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decodeIfPresent(String.self, forKey: .repoDescription)
        let stargazersCount = try container.decode(Int.self, forKey: .stargazersCount)
        let language = try container.decodeIfPresent(String.self, forKey: .language)
        let htmlUrl = try container.decode(String.self, forKey: .htmlUrl)
        let updatedAt = try container.decode(String.self, forKey: .updatedAt)
        let isBookmarked = try? container.decode(Bool.self, forKey: .isBookmarked)

        self.init(
            id: id,
            name: name,
            description: description,
            stargazersCount: stargazersCount,
            language: language,
            htmlUrl: htmlUrl,
            updatedAt: updatedAt,
            isBookmarked: isBookmarked ?? false
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(repoDescription, forKey: .repoDescription)
        try container.encode(stargazersCount, forKey: .stargazersCount)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encode(htmlUrl, forKey: .htmlUrl)
        try container.encode(updatedAt, forKey: .updatedAt)
        try? container.encode(isBookmarked, forKey: .isBookmarked)
    }

}
