//
//  RepoCellViewModel.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 15/05/25.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

class RepoCellViewModel {

    let repoTitle: BehaviorRelay<String>
    let starCount: BehaviorRelay<String>
    let isBookmarkImage: BehaviorRelay<UIImage>

    let repository: Repository

    init(repository: Repository) {
        self.repository = repository
        self.repoTitle = .init(value: repository.name)
        self.starCount = .init(value: String(repository.stargazersCount))
        self.isBookmarkImage = .init(value: UIImage(systemName: repository.isBookmarked ? "bookmark.fill" : "bookmark")!)
    }
}

