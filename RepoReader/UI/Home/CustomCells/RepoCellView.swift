//
//  RepoCellView.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 15/05/25.
//

import UIKit
import RxBinding
import RxSwift

class RepoCellView: UITableViewCell {
    // MARK: - Properties
    class var ID: String { String(describing: Self.self) }
    class var NIB: UINib { .init(nibName: String(describing: Self.self), bundle: .main) }

    @IBOutlet weak var repoTitleLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    
    var cellModel: RepoCellViewModel? {
        didSet {
            guard let cellModel = self.cellModel else { return }

            self.disposeBag ~ [
                cellModel.starCount ~> self.starCountLabel.rx.text,
                cellModel.repoTitle ~> self.repoTitleLabel.rx.text,
                cellModel.isBookmarkImage ~> self.bookmarkImageView.rx.image
            ]
        }

    }


    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
