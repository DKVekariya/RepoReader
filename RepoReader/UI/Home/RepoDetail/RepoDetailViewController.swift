//
//  RepoDetailViewController.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 15/05/25.
//

import UIKit
import RxSwift
import RxBinding

class RepoDetailViewController: UIViewController {

    @IBOutlet weak var repoTitleLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    
    var viewModel: RepoDetailViewModel!

    lazy var disposeBag: DisposeBag = {
        DisposeBag()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()


        initView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.didActionSubject.onNext(.onDismiss)
    }

    func initView() {
        title = "Repo Detail"
        setUpContentChangeObserver()
        setUpActionObservers()
    }
}

extension RepoDetailViewController {
    func setUpContentChangeObserver() {
        self.disposeBag ~ [
            // self.viewModel.repositoryTitle ~> self.repoTitleLabel.rx.text,

            self.viewModel.repositoryTitle ~> self.repoTitleLabel.rx.text,
            self.viewModel.starCount ~> self.starCountLabel.rx.text,
        ]

        viewModel.isBookmarked.asObservable().observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] isBookmarked in
            self?.bookmarkButton.setTitle(isBookmarked ? "Remove Bookmark" : "Add Bookmark", for: .normal)
            self?.bookmarkButton.setImage(UIImage(systemName: isBookmarked ? "bookmark.circle.fill" : "bookmark.circle"), for: .normal)
            self?.bookmarkImageView.image = UIImage(systemName: isBookmarked ? "bookmark.circle.fill" : "bookmark.circle")
        }) ~ disposeBag
    }

    func setUpActionObservers() {
        [
            bookmarkButton.rx.tap.map { RepoDetailViewModel.Action.onBookmarkTap }
            ~> viewModel.didActionSubject

        ] ~ disposeBag
    }

}

