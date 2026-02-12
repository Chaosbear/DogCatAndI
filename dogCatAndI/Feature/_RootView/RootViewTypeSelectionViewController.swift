//
//  RootViewTypeSelectionViewController.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 12/2/2569 BE.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

final class RootViewTypeSelectionViewController: UIViewController {
    // MARK: - Dependency
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    private let swiftUIButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SwiftUI", for: .normal)
        button.titleLabel?.font = DSFont.body1Bold.uifont
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor(DSColor.primaryWhite), for: .normal)
        button.backgroundColor = UIColor(DSColor.primaryBlue)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let uiKitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("UIKit+RxSwift", for: .normal)
        button.titleLabel?.font = DSFont.body1Bold.uifont
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor(DSColor.primaryWhite), for: .normal)
        button.backgroundColor = UIColor(DSColor.primaryBlue)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindAction()
    }

    // MARK: - Layout
    private func setupLayout() {
        view.backgroundColor = UIColor(DSColor.primaryWhite)

        // Add subviews
        view.addSubview(buttonStack)

        // Button stack
        buttonStack.addArrangedSubview(swiftUIButton)
        buttonStack.addArrangedSubview(uiKitButton)

        // Constraints
        NSLayoutConstraint.activate([
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            swiftUIButton.heightAnchor.constraint(equalToConstant: 44),
            swiftUIButton.widthAnchor.constraint(equalToConstant: 160),
            uiKitButton.heightAnchor.constraint(equalToConstant: 44),
            uiKitButton.widthAnchor.constraint(equalToConstant: 160),
        ])
    }

    // MARK: - Rx Bindings
    private func bindAction() {
        swiftUIButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentSwiftUIRootView()
            })
            .disposed(by: disposeBag)

        uiKitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentUIKitRootView()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Present ViewController
    private func presentSwiftUIRootView() {
        let rootView = RootView()
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.modalTransitionStyle = .crossDissolve
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }

    private func presentUIKitRootView() {
        let rootView = RxRootViewController()
        rootView.modalTransitionStyle = .crossDissolve
        rootView.modalPresentationStyle = .fullScreen
        present(rootView, animated: true)
    }
}
