//
//  InlineErrorCell.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 12/2/2569 BE.
//

import UIKit

final class InlineErrorCell: UITableViewCell {
    static var reuseIdentifier: String { "InlineErrorCell" }

    var retryAction: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DSFont.subTitle.uifont
        label.textColor = UIColor(DSColor.gray1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = DSFont.body2.uifont
        label.textColor = UIColor(DSColor.gray1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try again", for: .normal)
        button.titleLabel?.font = DSFont.body2Bold.uifont
        button.setTitleColor(UIColor(DSColor.primaryWhite), for: .normal)
        button.backgroundColor = UIColor(DSColor.primaryBlue)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        retryAction = nil
    }

    private func setupViews() {
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(messageLabel)
        stack.addArrangedSubview(retryButton)
        stack.setCustomSpacing(24, after: messageLabel)

        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            retryButton.widthAnchor.constraint(equalToConstant: 120),
            retryButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }

    @objc private func retryTapped() {
        retryAction?()
    }

    func configure(state: ErrorViewStateModel, retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
        titleLabel.text = state.title
        titleLabel.isHidden = state.title == nil
        messageLabel.text = state.message
        messageLabel.isHidden = state.message == nil
    }
}
