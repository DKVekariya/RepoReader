//
//  HomeViewModel.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 15/05/25.
//

import Foundation
import RxSwift
import RxBinding
import RxRelay

class HomeViewModel {
// - Published Properties
    let cells: BehaviorRelay<[RepoCellViewModel]> = BehaviorRelay(value: [])

    // input:
    lazy var didActionSubject = PublishSubject<Action>()

    // output:
    lazy var shouldPresentSubject = PublishSubject<ViewToPresent>()

    private var lastPage: Int = 0
    ///**@AppInject** With this we can inject the dependency
    private let repoRepository: RepoRepository
    private let databaseManager: DatabaseManager

    private let disposeBag = DisposeBag()

    init() {
        self.repoRepository = appResolve(serviceType: RepoRepository.self)
        self.databaseManager = appResolve(serviceType: DatabaseManager.self)

        fetchRepos()
        setUpActionObservers()
    }

    func loadNextPage() {
        fetchRepos(page: lastPage + 1)
    }

    func fetchRepos(page: Int? = nil) {
        if self.cells.value.isEmpty {
            startLoader()
        }
        Task {
            do {
                let repos = try await repoRepository.fetchRepos(page: page)
                stopLoader()
                databaseManager.insertRepositories(repos)
                let repositories = databaseManager.fetchAllRepositories()
                cells.accept(repositories.map { RepoCellViewModel(repository: $0) })
                self.lastPage = page ?? 0
            } catch {
                stopLoader()
                print("Error fetching repos: \(AppError(error: error).message)")
                showAlert()
            }
        }
    }

    func repositoryUpdated(repoId: Int) {
        let repo = databaseManager.fetchRepository(byId: repoId)
        var cellModels = cells.value
        if let repo, let index = cells.value.firstIndex(where: { $0.repository.id == repoId }) {
            cellModels[index] = .init(repository: repo)
            cells.accept(cellModels)
        }
    }

    func startLoader() {
        shouldPresentSubject.onNext(.loadingIndicator(true))
    }

    func stopLoader() {
        shouldPresentSubject.onNext(.loadingIndicator(false))
    }

    func showAlert() {
        shouldPresentSubject.onNext(.showAlert(title: "Oops!", message: "Something went wrong, Please try again later."))
    }
}

// MARK: - Actions
extension HomeViewModel {
    func setUpActionObservers() {
        self.didActionSubject.asObservable()
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .itemSelected(let indexPath):
                    let repo = self.cells.value[indexPath.row]

                    self.shouldPresentSubject
                        .onNext(.showRepoDetail(
                            RepoDetailViewModel(repoId: repo.repository.id,
                                                onDismiss: { [weak self] repoId in
                                                    guard let self else { return }
                                                    self.repositoryUpdated(repoId: repoId)
                                                }
                                               ))
                        )
                case .onLoadNextPage:
                    self.loadNextPage()
                }
            }) ~ self.disposeBag
    }
}

// MARK: - Actions and Presenting
extension HomeViewModel {
    enum Action {
        case itemSelected(IndexPath)
        case onLoadNextPage
    }

    enum ViewToPresent {
        case loadingIndicator(Bool)
        case showAlert(title: String, message: String)
        case showRepoDetail(RepoDetailViewModel)
    }
}
