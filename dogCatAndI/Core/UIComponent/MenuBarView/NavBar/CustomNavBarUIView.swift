//
//  CustomNavBarUIView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 10/2/2569 BE.
//

import UIKit

final class CustomNavBarUIView: UIView {
    // MARK: - Property
    private let isPhone = UIDevice.isPhone

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentView: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()

    // MARK: - Init
    init(
        title: String,
        titleFont: UIFont = DSFont.body1Bold.uifont,
        barHeight: CGFloat = UIDevice.isPhone ? 64 : 72,
        bgColor: UIColor = UIColor(DSColor.primaryWhite),
        leadingView: UIView? = nil,
        trailingView: UIView? = nil
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = bgColor

        titleLabel.text = title
        titleLabel.font = titleFont
        titleLabel.textColor = UIColor(DSColor.black)

        setupLayout(
            barHeight: barHeight,
            leadingView: leadingView,
            trailingView: trailingView
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Layout
    private func setupLayout(
        barHeight: CGFloat,
        leadingView: UIView?,
        trailingView: UIView?
    ) {
        addSubview(contentView)
        contentView.addSubview(titleLabel)

        let titlePadding: CGFloat = isPhone ? 40 : 44

        var constraints: [NSLayoutConstraint] = [
            // Content view with 16pt horizontal padding
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Fixed height
            heightAnchor.constraint(equalToConstant: barHeight),

            // Title centered with padding to avoid overlapping icons
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: titlePadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -titlePadding),
        ]

        if let leading = leadingView {
            leading.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(leading)
            constraints.append(contentsOf: [
                leading.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                leading.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
        }

        if let trailing = trailingView {
            trailing.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(trailing)
            constraints.append(contentsOf: [
                trailing.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                trailing.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
        }

        NSLayoutConstraint.activate(constraints)
    }
}
