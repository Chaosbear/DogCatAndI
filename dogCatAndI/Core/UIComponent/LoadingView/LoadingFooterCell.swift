//
//  LoadingFooterCell.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 12/2/2569 BE.
//

import UIKit

final class LoadingFooterCell: UITableViewCell {
    static var reuseIdentifier: String { "LoadingFooterCell" }

    private let spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        spinner.hidesWhenStopped = false
        contentView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            spinner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
        spinner.startAnimating()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        spinner.stopAnimating()
    }

    func startAnimation() {
        spinner.startAnimating()
    }
}
