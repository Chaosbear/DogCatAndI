//
//  CustomTabbarUIView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 10/2/2569 BE.
//

import UIKit

final class CustomTabbarUIView: UIView {
    // MARK: - Property
    private let isPhone = UIDevice.isPhone
    private var tabItemViews: [TabItemView] = []
    private(set) var selectedIndex: Int = 0

    var onTabSelected: ((Int) -> Void)?

    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .bottom
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init
    init(tabs: [CustomTabbarItem], selectedIndex: Int = 0) {
        self.selectedIndex = selectedIndex
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(DSColor.primaryWhite)

        setupLayout()
        configureTabs(tabs)
        updateSelection()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public
    func selectTab(at index: Int) {
        guard index >= 0 && index < tabItemViews.count else { return }
        selectedIndex = index
        updateSelection()
    }

    // MARK: - Layout
    private func setupLayout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func configureTabs(_ tabs: [CustomTabbarItem]) {
        for (index, tab) in tabs.enumerated() {
            let itemView = TabItemView(tab: tab, isPhone: isPhone)
            itemView.tag = index
            let tap = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
            itemView.addGestureRecognizer(tap)
            stackView.addArrangedSubview(itemView)
            tabItemViews.append(itemView)
        }
    }

    private func updateSelection() {
        for (index, itemView) in tabItemViews.enumerated() {
            itemView.setSelected(index == selectedIndex)
        }
    }

    @objc private func tabTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let index = view.tag
        guard index != selectedIndex else { return }
        selectedIndex = index
        updateSelection()
        onTabSelected?(index)
    }
}

// MARK: - TabItemView
private class TabItemView: UIView {
    private let iconView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(DSColor.black)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(tab: CustomTabbarItem, isPhone: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        let iconSize: CGFloat = isPhone ? 28 : 32
        iconView.image = UIImage(named: tab.image)?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = tab.title

        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: iconSize),
            iconView.heightAnchor.constraint(equalToConstant: iconSize),

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: isPhone ? 10 : 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: isPhone ? -4 : -12),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func setSelected(_ selected: Bool) {
        titleLabel.font = selected ? DSFont.body2Bold.uifont : DSFont.body2.uifont
        titleLabel.textColor = selected ? UIColor(DSColor.primaryBlue) : UIColor(DSColor.black)
    }
}
