//
//  ErrorUIView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 10/2/2569 BE.
//

import UIKit

final class ErrorUIView: UIView {
    // MARK: - Property
    private var retryAction: (() -> Void)?
    private let imageSize: CGSize

    // MARK: - UI Components
    private let errorImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(DSColor.gray3)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

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

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init
    init(imageSize: CGSize = CGSize(width: 160, height: 160)) {
        self.imageSize = imageSize
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.backgroundColor = UIColor(DSColor.primaryWhite)
        scroll.alwaysBounceVertical = true
        scroll.bounces = true

        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    // MARK: - Setup
    private func setupViews() {
        stackView.addArrangedSubview(errorImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(retryButton)

        stackView.setCustomSpacing(12, after: errorImageView)
        stackView.setCustomSpacing(8, after: titleLabel)
        stackView.setCustomSpacing(24, after: messageLabel)

        addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -12),

            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            errorImageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            errorImageView.heightAnchor.constraint(equalToConstant: imageSize.height),

            retryButton.widthAnchor.constraint(equalToConstant: 120),
            retryButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        clipsToBounds = true
    }

    @objc private func retryTapped() {
        retryAction?()
    }

    func configure(state: ErrorViewStateModel, retryAction: @escaping () -> Void) {
        self.retryAction = retryAction

        if let imageName = state.image {
            errorImageView.image = UIImage(systemName: imageName)
            errorImageView.isHidden = false
        } else {
            errorImageView.isHidden = true
        }

        titleLabel.text = state.title
        titleLabel.isHidden = state.title == nil

        messageLabel.text = state.message
        messageLabel.isHidden = state.message == nil
    }
}
