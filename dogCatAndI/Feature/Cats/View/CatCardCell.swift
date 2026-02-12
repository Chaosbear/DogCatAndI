//
//  CatCardUIView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 10/2/2569 BE.
//

import UIKit
import SkeletonView

struct CatBreedCellModel: Equatable {
    let breed: Cats.FetchBreeds.ViewModel.BreedItem
    let isExpanded: Bool
}

final class CatBreedCell: UITableViewCell {
    static let reuseIdentifier = "CatBreedCell"

    var onToggleExpand: (() -> Void)?

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let headerContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.isSkeletonable = true
        return container
    }()

    private let breedLabel: UILabel = {
        let label = UILabel()
        label.font = DSFont.body1.uifont
        label.textColor = UIColor(DSColor.black)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        return label
    }()

    private let chevronImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.down")
        image.tintColor = UIColor(DSColor.gray1)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let headerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let headerDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(DSColor.black)
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()

    private let detailDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(DSColor.black)
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()

    private let detailContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private let detailStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let countryValue = UILabel()
    private let originValue = UILabel()
    private let coatValue = UILabel()
    private let patternValue = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        isSkeletonable = true
        contentView.isSkeletonable = true
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        onToggleExpand = nil
        detailContainer.isHidden = true
        detailDivider.isHidden = true
        chevronImageView.transform = .identity
    }

    private func setupViews() {
        contentView.addSubview(mainStack)

        // Header
        headerContainer.addSubview(breedLabel)
        headerContainer.addSubview(chevronImageView)
        headerContainer.addSubview(headerButton)

        // Detail rows
        let rows: [(String, UILabel)] = [
            ("Country: ", countryValue),
            ("Origin: ", originValue),
            ("Coat: ", coatValue),
            ("Pattern: ", patternValue),
        ]
        for (labelText, valueLabel) in rows {
            let label = UILabel()
            label.font = DSFont.body3.uifont
            label.textColor = UIColor(DSColor.gray1)
            label.text = labelText
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)

            valueLabel.font = DSFont.body3.uifont
            valueLabel.textColor = UIColor(DSColor.black)
            valueLabel.numberOfLines = 0
            valueLabel.translatesAutoresizingMaskIntoConstraints = false

            let row = UIStackView(arrangedSubviews: [label, valueLabel])
            row.axis = .horizontal
            row.alignment = .top
            row.spacing = 0
            label.widthAnchor.constraint(equalToConstant: 70).isActive = true

            detailStack.addArrangedSubview(row)
        }
        detailContainer.addSubview(detailStack)

        // Divider heights
        headerDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        detailDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // Stack arrangement
        mainStack.addArrangedSubview(headerContainer)
        mainStack.addArrangedSubview(headerDivider)
        mainStack.addArrangedSubview(detailContainer)
        mainStack.addArrangedSubview(detailDivider)

        detailContainer.isHidden = true
        detailDivider.isHidden = true

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            breedLabel.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 8),
            breedLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            breedLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            breedLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -8),

            chevronImageView.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),

            headerButton.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            headerButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            headerButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            headerButton.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),

            detailStack.topAnchor.constraint(equalTo: detailContainer.topAnchor, constant: 8),
            detailStack.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor, constant: 32),
            detailStack.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor, constant: -16),
            detailStack.bottomAnchor.constraint(equalTo: detailContainer.bottomAnchor, constant: -8),
        ])

        headerButton.addTarget(self, action: #selector(headerTapped), for: .touchUpInside)
    }

    @objc private func headerTapped() {
        onToggleExpand?()
    }

    func configure(with model: CatBreedCellModel) {
        breedLabel.text = model.breed.breed
        detailContainer.isHidden = !model.isExpanded
        detailDivider.isHidden = !model.isExpanded
        chevronImageView.transform = model.isExpanded
            ? CGAffineTransform(rotationAngle: .pi)
            : .identity
        countryValue.text = model.breed.country
        originValue.text = model.breed.origin
        coatValue.text = model.breed.coat
        patternValue.text = model.breed.pattern
    }
}
