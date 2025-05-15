//
//  LoaderTableViewCell.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 15/05/25.
//

import UIKit

class LoaderTableViewCell: UITableViewCell {
    // MARK: - Properties
    class var ID: String { String(describing: Self.self) }
    class var NIB: UINib { .init(nibName: String(describing: Self.self), bundle: .main) }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
