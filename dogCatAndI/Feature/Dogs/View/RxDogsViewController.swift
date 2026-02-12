//
//  RxDogsViewController.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 10/2/2569 BE.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import SkeletonView

struct DogSectionModel: SectionModelType {
    typealias Item = Dogs.FetchDogs.ViewModel.DogItem

    var items: [Item]

    init(items: [Item]) {
        self.items = items
    }

    init(original: DogSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

final class RxDogsViewController: UIViewController {
    // MARK: - Dependency
    private let viewState: RxDogsViewState
    private let interactor: DogsBusinessLogic
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Dogs"
        label.font = DSFont.h2.uifont
        label.textColor = UIColor(DSColor.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionLayout())
        view.backgroundColor = .clear
        view.register(DogCardCell.self, forCellWithReuseIdentifier: DogCardCell.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSkeletonable = true
        return view
    }()

    private let errorView: ErrorUIView = {
        let view = ErrorUIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let concurrentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Concurrent\nReload", for: .normal)
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

    private let sequentialButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sequential\nReload", for: .normal)
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

    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 32
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let contentArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    init(viewState: RxDogsViewState, interactor: DogsBusinessLogic) {
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

        if viewState.dogs.value.isEmpty {
            interactor.fetchDogs(loadType: viewState.currentLoadType)
        }
    }

    // MARK: - Layout
    private func setupLayout() {
        view.backgroundColor = UIColor(DSColor.primaryWhite)

        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(contentArea)
        view.addSubview(buttonStack)

        contentArea.isSkeletonable = true
        contentArea.addSubview(collectionView)
        contentArea.addSubview(errorView)

        // Button stack
        buttonStack.addArrangedSubview(concurrentButton)
        buttonStack.addArrangedSubview(sequentialButton)

        // Constraints
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Content area
            contentArea.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            contentArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentArea.bottomAnchor.constraint(equalTo: buttonStack.topAnchor),

            // Collection view fills content area
            collectionView.topAnchor.constraint(equalTo: contentArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentArea.bottomAnchor),

            // Error view centered in content area
            errorView.topAnchor.constraint(equalTo: contentArea.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: contentArea.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),

            // Button stack
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),

            concurrentButton.heightAnchor.constraint(equalToConstant: 40),
            sequentialButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    // MARK: - Collection Layout
    private func makeCollectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, environment in
            let availableWidth = environment.container.effectiveContentInsets.leading
                + environment.container.contentSize.width
                - environment.container.effectiveContentInsets.trailing
            let usableWidth = availableWidth - 32 // 16pt inset each side
            let minItemWidth: CGFloat = 120
            let spacing: CGFloat = 16
            let columnCount = max(1, Int((usableWidth + spacing) / (minItemWidth + spacing)))
            let itemWidth = (usableWidth - spacing * CGFloat(columnCount - 1)) / CGFloat(columnCount)

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .estimated(180)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(180)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: Array(repeating: item, count: columnCount)
            )
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 16, bottom: 16, trailing: 16)
            return section
        }
    }

    // MARK: - Rx Bindings
    private func bindViewModel() {
        // Dog list data source
        let dataSource = RxCollectionViewSectionedReloadDataSource<DogSectionModel>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DogCardCell.reuseIdentifier,
                    for: indexPath
                ) as! DogCardCell
                cell.configure(with: item)
                return cell
            }
        )

        viewState.dogs
            .map { [DogSectionModel(items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
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
            if showSkeleton {
                let gradient = SkeletonGradient(
                    baseColor: UIColor(DSColor.gray4),
                    secondaryColor: UIColor(DSColor.gray5)
                )
                self.collectionView.showAnimatedGradientSkeleton(
                    usingGradient: gradient,
                    transition: .crossDissolve(0.25)
                )
            } else {
                self.collectionView.hideSkeleton(transition: .crossDissolve(0.25))
            }
        })
        .disposed(by: disposeBag)

        // Error view visibility and content
        viewState.errorState
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                guard let self else { return }
                let hasError = state != .noError
                self.errorView.isHidden = !hasError

                if hasError {
                    self.errorView.configure(state: state) { [weak self] in
                        guard let self else { return }
                        self.interactor.fetchDogs(loadType: self.viewState.currentLoadType)
                    }
                }
            })
            .disposed(by: disposeBag)

        // Button taps
        concurrentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.interactor.fetchDogs(loadType: .concurrent)
            })
            .disposed(by: disposeBag)

        sequentialButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.interactor.fetchDogs(loadType: .sequential)
            })
            .disposed(by: disposeBag)
    }
}
