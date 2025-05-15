//
//  RepoDetailViewModel.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 15/05/25.
//

import Foundation
import RxRelay
import RxSwift
import UIKit
import RxBinding

class RepoDetailViewModel {
    let repositoryTitle: BehaviorRelay<String> = .init(value: "")
    let starCount: BehaviorRelay<String> = .init(value: "")
    let isBookmarked: BehaviorRelay<Bool> = .init(value: false)

    // input:
    lazy var didActionSubject = PublishSubject<Action>()

    // output:
    lazy var shouldPresentSubject = PublishSubject<ViewToPresent>()

    private let databaseManager: DatabaseManager

    private let repositoryId: Int
    private var repository: Repository?

    var onDismiss: ((_ repoId: Int) -> Void)?

    private lazy var disposeBag = {
        DisposeBag()
    }()

    init(repoId: Int, onDismiss: ((_ repoId: Int) -> Void)? = nil) {
        self.repositoryId = repoId
        self.onDismiss = onDismiss
        self.databaseManager = appResolve(serviceType: DatabaseManager.self)

        fetchRepoDetails()
        setUpActionObservers()
    }

    private func fetchRepoDetails() {
        let repo = databaseManager.fetchRepository(byId: repositoryId)
        repository = repo
        setupPublishedProperties()
    }

    func onBookmarkTap() {
        guard let repository = repository else { return }
        databaseManager.toggleBookmark(forRepositoryId: repositoryId, isBookmarked: repository.isBookmarked)
        self.repository?.isBookmarked.toggle()
        setupPublishedProperties()
    }

    func setupPublishedProperties() {
        guard let repository = repository else { return }
        self.repositoryTitle.accept(repository.name)
        self.starCount.accept(String(repository.stargazersCount))
        self.isBookmarked.accept(repository.isBookmarked)
    }
}

// MARK: - Actions
extension RepoDetailViewModel {
    func setUpActionObservers() {
        self.didActionSubject.asObservable()
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .onBookmarkTap:
                    self.onBookmarkTap()
                case .onDismiss:
                    self.onDismiss?(self.repositoryId)
                }
            }) ~ self.disposeBag
    }
}

// MARK: - Actions and Presenting
extension RepoDetailViewModel {
    enum Action {
        case onBookmarkTap
        case onDismiss
    }

    enum ViewToPresent {
        case loadingIndicator(Bool)
        case showAlert(title: String, message: String)
        case pop
    }
}
