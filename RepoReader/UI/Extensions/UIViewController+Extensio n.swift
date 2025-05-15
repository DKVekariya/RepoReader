//
//  UIViewController+Extensio n.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 15/05/25.
//

import UIKit

protocol AlertDialogProtocol {

    func showAlert(title: String?, message: String?, positiveButton: String?, positiveStyle: UIAlertAction.Style, positiveCompletion: @escaping () -> Void, negativeButton: String?, negativeCompletion: @escaping () -> Void)
}

// MARK: - Where extended by UIViewController
extension AlertDialogProtocol where Self: UIViewController {

    func showAlert(title: String?, message: String?, positiveButton: String? = "ok", positiveStyle: UIAlertAction.Style = .default, positiveCompletion: @escaping () -> Void = {}, negativeButton: String? = nil, negativeCompletion: @escaping () -> Void = {}) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: positiveButton, style: positiveStyle) { _ in
            positiveCompletion()
        })

        if let negative = negativeButton {
            alertController.addAction(UIAlertAction(title: negative, style: .cancel) { _ in
                negativeCompletion()
            })
        }

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
