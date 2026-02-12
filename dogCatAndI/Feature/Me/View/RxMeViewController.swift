//
//  RxMeViewController.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 10/2/2569 BE.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SkeletonView

final class RxMeViewController: UIViewController {
    // MARK: - Dependency
    private let viewState: RxMeViewState
    private let interactor: MeBusinessLogic
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Me"
        label.font = DSFont.h1.uifont
        label.textColor = UIColor(DSColor.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentArea: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()

    // Profile scroll view
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 80
        image.image = UIImage(named: "image_placeholder")
        image.backgroundColor = .systemGray6
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let detailStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // Value labels
    private let titleValue = UILabel()
    private let firstNameValue = UILabel()
    private let lastNameValue = UILabel()
    private let dobValue = UILabel()
    private let ageValue = UILabel()
    private let genderIconView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let nationalityValue = UILabel()
    private let mobileValue = UILabel()
    private let addressValue = UILabel()

    // Skeleton overlay
    private let skeletonContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(DSColor.primaryWhite)
        container.isHidden = true
        container.isSkeletonable = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private let errorView: ErrorUIView = {
        let error = ErrorUIView()
        error.isHidden = true
        error.translatesAutoresizingMaskIntoConstraints = false
        return error
    }()

    // Reload button
    private let reloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reload Profile", for: .normal)
        button.titleLabel?.font = DSFont.body3.uifont
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor(DSColor.primaryWhite), for: .normal)
        button.backgroundColor = UIColor(DSColor.primaryBlue)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(DSColor.black).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init
    init(viewState: RxMeViewState, interactor: MeBusinessLogic) {
        self.viewState = viewState
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindViewModel()

        if viewState.profile.value == nil {
            interactor.fetchProfile()
        }
    }

    // MARK: - Layout
    private func setupLayout() {
        view.backgroundColor = UIColor(DSColor.primaryWhite)

        view.addSubview(titleLabel)
        view.addSubview(contentArea)
        view.addSubview(reloadButton)

        contentArea.addSubview(scrollView)
        contentArea.addSubview(skeletonContainer)
        contentArea.addSubview(errorView)

        scrollView.addSubview(contentStack)

        // Profile image
        contentStack.addArrangedSubview(profileImageView)

        // Detail rows
        let topRows: [(String, UILabel)] = [
            ("Title: ", titleValue),
            ("Firstname: ", firstNameValue),
            ("Lastname: ", lastNameValue),
            ("Date of Birth: ", dobValue),
            ("Age: ", ageValue),
        ]
        for (labelText, valueLabel) in topRows {
            detailStack.addArrangedSubview(makeProfileRow(labelText: labelText, valueLabel: valueLabel))
        }

        detailStack.addArrangedSubview(makeGenderRow())

        let bottomRows: [(String, UILabel)] = [
            ("Nationality: ", nationalityValue),
            ("Mobile: ", mobileValue),
            ("Address: ", addressValue),
        ]
        for (labelText, valueLabel) in bottomRows {
            detailStack.addArrangedSubview(makeProfileRow(labelText: labelText, valueLabel: valueLabel))
        }

        contentStack.addArrangedSubview(detailStack)

        // Skeleton
        setupSkeleton()

        // Preferred button width
        let preferredWidth = reloadButton.widthAnchor.constraint(equalToConstant: 240)
        preferredWidth.priority = .defaultHigh

        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Content area
            contentArea.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            contentArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentArea.bottomAnchor.constraint(equalTo: reloadButton.topAnchor),

            // Scroll view fills content area
            scrollView.topAnchor.constraint(equalTo: contentArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentArea.bottomAnchor),

            // Content stack inside scroll view
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 48),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -48),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -12),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -96),

            // Profile image
            profileImageView.widthAnchor.constraint(equalToConstant: 160),
            profileImageView.heightAnchor.constraint(equalToConstant: 160),

            // Detail stack fills width
            detailStack.widthAnchor.constraint(equalTo: contentStack.widthAnchor),

            // Skeleton overlay
            skeletonContainer.topAnchor.constraint(equalTo: contentArea.topAnchor),
            skeletonContainer.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            skeletonContainer.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            skeletonContainer.bottomAnchor.constraint(equalTo: contentArea.bottomAnchor),

            // Error view fills content area
            errorView.topAnchor.constraint(equalTo: contentArea.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: contentArea.bottomAnchor),

            // Reload button
            reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            preferredWidth,
            reloadButton.widthAnchor.constraint(lessThanOrEqualToConstant: 240),
            reloadButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            reloadButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32),
            reloadButton.heightAnchor.constraint(equalToConstant: 40),
            reloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
    }

    private func makeProfileRow(labelText: String, valueLabel: UILabel) -> UIView {
        let label = UILabel()
        label.font = DSFont.body1.uifont
        label.textColor = UIColor(DSColor.gray1)
        label.text = labelText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        valueLabel.font = DSFont.body1.uifont
        valueLabel.textColor = UIColor(DSColor.black)
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        let row = UIStackView(arrangedSubviews: [label, valueLabel])
        row.axis = .horizontal
        row.alignment = .top
        row.spacing = 0
        label.widthAnchor.constraint(equalToConstant: 110).isActive = true

        return row
    }

    private func makeGenderRow() -> UIView {
        let label = UILabel()
        label.font = DSFont.body1.uifont
        label.textColor = UIColor(DSColor.gray1)
        label.text = "Gender: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            genderIconView.widthAnchor.constraint(equalToConstant: 24),
            genderIconView.heightAnchor.constraint(equalToConstant: 24),
        ])

        let row = UIStackView(arrangedSubviews: [label, genderIconView])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 0
        label.widthAnchor.constraint(equalToConstant: 110).isActive = true

        return row
    }

    private func setupSkeleton() {
        let skeletonStack = UIStackView()
        skeletonStack.axis = .vertical
        skeletonStack.spacing = 24
        skeletonStack.alignment = .center
        skeletonStack.isSkeletonable = true
        skeletonStack.translatesAutoresizingMaskIntoConstraints = false

        // Circle placeholder
        let circlePlaceholder = UIView()
        circlePlaceholder.layer.cornerRadius = 80
        circlePlaceholder.clipsToBounds = true
        circlePlaceholder.isSkeletonable = true
        circlePlaceholder.skeletonCornerRadius = 80
        circlePlaceholder.translatesAutoresizingMaskIntoConstraints = false

        // Rect placeholders
        let rectStack = UIStackView()
        rectStack.axis = .vertical
        rectStack.spacing = 12
        rectStack.isSkeletonable = true
        rectStack.translatesAutoresizingMaskIntoConstraints = false

        let rect1 = makeSkeletonRect()
        let rect2 = makeSkeletonRect()

        // Third rect is shorter (trailing padding 120)
        let rect3Container = UIView()
        rect3Container.translatesAutoresizingMaskIntoConstraints = false
        rect3Container.isSkeletonable = true
        let rect3 = makeSkeletonRect()
        rect3Container.addSubview(rect3)

        rectStack.addArrangedSubview(rect1)
        rectStack.addArrangedSubview(rect2)
        rectStack.addArrangedSubview(rect3Container)

        skeletonStack.addArrangedSubview(circlePlaceholder)
        skeletonStack.addArrangedSubview(rectStack)

        skeletonContainer.addSubview(skeletonStack)

        NSLayoutConstraint.activate([
            skeletonStack.topAnchor.constraint(equalTo: skeletonContainer.topAnchor, constant: 12),
            skeletonStack.leadingAnchor.constraint(equalTo: skeletonContainer.leadingAnchor, constant: 48),
            skeletonStack.trailingAnchor.constraint(equalTo: skeletonContainer.trailingAnchor, constant: -48),

            circlePlaceholder.widthAnchor.constraint(equalToConstant: 160),
            circlePlaceholder.heightAnchor.constraint(equalToConstant: 160),

            rectStack.widthAnchor.constraint(equalTo: skeletonStack.widthAnchor),

            rect1.heightAnchor.constraint(equalToConstant: 20),
            rect2.heightAnchor.constraint(equalToConstant: 20),

            rect3.topAnchor.constraint(equalTo: rect3Container.topAnchor),
            rect3.leadingAnchor.constraint(equalTo: rect3Container.leadingAnchor),
            rect3.bottomAnchor.constraint(equalTo: rect3Container.bottomAnchor),
            rect3.trailingAnchor.constraint(equalTo: rect3Container.trailingAnchor, constant: -120),
            rect3.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    private func makeSkeletonRect() -> UIView {
        let skeleton = UIView()
        skeleton.layer.cornerRadius = 4
        skeleton.clipsToBounds = true
        skeleton.isSkeletonable = true
        skeleton.skeletonCornerRadius = 4
        skeleton.translatesAutoresizingMaskIntoConstraints = false
        return skeleton
    }

    // MARK: - Rx Bindings
    private func bindViewModel() {
        // Profile data
        viewState.profile
            .subscribe(onNext: { [weak self] profile in
                guard let self else { return }
                self.titleValue.text = profile?.title
                self.firstNameValue.text = profile?.firstName
                self.lastNameValue.text = profile?.lastName
                self.dobValue.text = profile?.dateOfBirth
                self.ageValue.text = profile?.age
                self.nationalityValue.text = profile?.nationality
                self.mobileValue.text = profile?.mobile
                self.addressValue.text = profile?.address

                if let gender = profile?.gender, !gender.isEmpty {
                    self.genderIconView.image = UIImage(named: gender.lowercased() == "male" ? "ic_male" : "ic_female")
                    self.genderIconView.isHidden = false
                } else {
                    self.genderIconView.isHidden = true
                }

                if let url = profile?.profileImageURL {
                    self.profileImageView.kf.setImage(
                        with: url,
                        placeholder: UIImage(named: "image_placeholder")
                    )
                } else {
                    self.profileImageView.kf.cancelDownloadTask()
                    self.profileImageView.image = UIImage(named: "image_placeholder")
                }
            })
            .disposed(by: disposeBag)

        // Skeleton visibility: show when loading AND no error
        Observable.combineLatest(
            viewState.isLoading.asObservable(),
            viewState.errorState.asObservable()
        )
        .map { isLoading, errorState in
            isLoading && errorState == .noError
        }
        .distinctUntilChanged()
        .subscribe(onNext: { [weak self] showSkeleton in
            guard let self else { return }
            self.skeletonContainer.isHidden = !showSkeleton
            if showSkeleton {
                let gradient = SkeletonGradient(
                    baseColor: UIColor(DSColor.gray4),
                    secondaryColor: UIColor(DSColor.gray5)
                )
                self.skeletonContainer.showAnimatedGradientSkeleton(
                    usingGradient: gradient,
                    transition: .crossDissolve(0.25)
                )
            } else {
                self.skeletonContainer.hideSkeleton(transition: .crossDissolve(0.25))
            }
        })
        .disposed(by: disposeBag)

        // Error view visibility
        viewState.errorState
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                guard let self else { return }
                let hasError = state != .noError
                self.errorView.isHidden = !hasError

                if hasError {
                    self.errorView.configure(state: state) { [weak self] in
                        self?.interactor.fetchProfile()
                    }
                }
            })
            .disposed(by: disposeBag)

        // Reload button
        reloadButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.interactor.fetchProfile()
            })
            .disposed(by: disposeBag)
    }
}
