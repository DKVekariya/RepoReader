//
//  HomeViewController.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 15/05/25.
//

import UIKit
import RxSwift
import RxBinding
import NVActivityIndicatorView

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: HomeViewModel = .init()

    var cells: [RepoCellViewModel] = []

    lazy var disposeBag = {
        DisposeBag()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    /// This method should be called only once
    func initView() {
        title = "Repos"

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(RepoCellView.NIB, forCellReuseIdentifier: RepoCellView.ID)
        tableView.register(LoaderTableViewCell.NIB, forCellReuseIdentifier: LoaderTableViewCell.ID)
        setUpObservers()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count + (cells.count > 0 ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < cells.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: RepoCellView.ID, for: indexPath) as! RepoCellView
            let cellViewModel = cells[indexPath.row]
            cell.cellModel = cellViewModel
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoaderTableViewCell.ID, for: indexPath) as! LoaderTableViewCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == cells.count && !cells.isEmpty {
            viewModel.didActionSubject.onNext(.onLoadNextPage)
            print("Loading next page")
        }
    }
}

// MARK: - Loading Indicator and alert
extension HomeViewController: AlertDialogProtocol {
    func startLoading() {
            self.LoaderView.isHidden = false
            self.activityIndicator.startAnimating()
    }

    func dismissLoading() {
            self.LoaderView.isHidden = true
            self.activityIndicator.stopAnimating()
    }
}


// MARK: - Observer Methods
extension HomeViewController {

    func setUpObservers() {
        setUpContentChangeObservers()
        setUpTableViewObservers()
        setUpShouldPresentObservers()
    }

    func setUpContentChangeObservers() {
        viewModel.cells.asObservable().observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] repos in
                self?.cells = repos
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }

    func setUpTableViewObservers() {
        self.tableView.rx.itemSelected.map { HomeViewModel.Action.itemSelected($0) }
        ~> self.viewModel.didActionSubject
        ~ self.disposeBag
    }

    func setUpShouldPresentObservers() {
        self.viewModel.shouldPresentSubject.asObservable().observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] viewToPresent in
                switch viewToPresent {
                case .loadingIndicator(let loading):
                    loading ? self.startLoading() : self.dismissLoading()
                case .showAlert(let title, let message):
                    self.showAlert(title: title, message: message)
                case .showRepoDetail(let RepoDetailViewModel):
                    print("Navigating to Repo Detail")
                    let repoDetailVC = RepoDetailViewController()
                    repoDetailVC.viewModel = RepoDetailViewModel
                    self.navigationController?.pushViewController(repoDetailVC, animated: true)
                }
            }) ~ self.disposeBag
    }
}
