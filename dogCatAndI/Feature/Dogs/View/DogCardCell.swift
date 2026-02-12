//
//  DogCardCell.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 11/2/2569 BE.
//

import UIKit
import SkeletonView
import Kingfisher

// MARK: - DogCardCell
final class DogCardCell: UICollectionViewCell {
    static var reuseIdentifier: String { "DogCardCell" }

    private let dogImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "image_placeholder")
        image.backgroundColor = UIColor(DSColor.gray4)
        image.isSkeletonable = true
        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DSFont.body3.uifont
        label.textColor = UIColor(DSColor.black)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        return label
    }()

    private let cardContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(DSColor.gray5)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSkeletonable = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        contentView.isSkeletonable = true
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        dogImageView.kf.cancelDownloadTask()
        dogImageView.image = UIImage(named: "image_placeholder")
    }

    private func setupViews() {
        contentView.addSubview(cardContentView)
        cardContentView.addSubview(dogImageView)
        cardContentView.addSubview(titleLabel)

        // shadow on contentView
        contentView.layer.shadowColor = UIColor(DSColor.gray3).cgColor
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowOpacity = 1

        NSLayoutConstraint.activate([
            cardContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            dogImageView.topAnchor.constraint(equalTo: cardContentView.topAnchor, constant: 12),
            dogImageView.leadingAnchor.constraint(equalTo: cardContentView.leadingAnchor, constant: 12),
            dogImageView.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor, constant: -12),
            dogImageView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.topAnchor.constraint(equalTo: dogImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardContentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardContentView.bottomAnchor, constant: -12),
        ])
    }

    func configure(with item: Dogs.FetchDogs.ViewModel.DogItem) {
        titleLabel.text = item.label
        dogImageView.kf.setImage(
            with: item.imageURL,
            placeholder: UIImage(named: "image_placeholder")
        )
    }
}
