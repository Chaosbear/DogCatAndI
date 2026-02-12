//
//  RxCatsViewController.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 10/2/2569 BE.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SkeletonView
import OrderedCollections

enum CatListItem: Equatable {
    case breed(CatBreedCellModel)
    case loading
    case error(ErrorViewStateModel)
}

struct CatSectionModel: SectionModelType {
    typealias Item = CatListItem
    var items: [Item]

    init(items: [Item]) {
        self.items = items
    }

    init(original: CatSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

final class RxCatsViewController: UIViewController {
    // MARK: - Dependency
    private let viewState: RxCatsViewState
    private let interactor: CatsBusinessLogic
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cats"
        label.font = DSFont.h1.uifont
        label.textColor = UIColor(DSColor.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let borderedContainer: UIView = {
        let container = UIView()
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(DSColor.black).cgColor
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cat Breeds"
        label.font = DSFont.h3.uifont
        label.textColor = UIColor(DSColor.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleDivider: UIView = {
        let subtitle = UIView()
        subtitle.backgroundColor = UIColor(DSColor.black)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        return subtitle
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 44
        table.register(CatBreedCell.self, forCellReuseIdentifier: CatBreedCell.reuseIdentifier)
        table.register(LoadingFooterCell.self, forCellReuseIdentifier: LoadingFooterCell.reuseIdentifier)
        table.register(InlineErrorCell.self, forCellReuseIdentifier: InlineErrorCell.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isSkeletonable = true
        return table
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()

    private let errorView: ErrorUIView = {
        let error = ErrorUIView()
        error.isHidden = true
        error.translatesAutoresizingMaskIntoConstraints = false
        return error
    }()

    // MARK: - Init
    init(viewState: RxCatsViewState, interactor: CatsBusinessLogic) {
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

        if viewState.breeds.value.isEmpty {
            Task { await interactor.fetchBreeds() }
        }
    }

    // MARK: - Layout
    private func setupLayout() {
        view.backgroundColor = UIColor(DSColor.primaryWhite)

        view.addSubview(titleLabel)
        view.addSubview(borderedContainer)

        borderedContainer.isSkeletonable = true
        borderedContainer.addSubview(subtitleLabel)
        borderedContainer.addSubview(subtitleDivider)
        borderedContainer.addSubview(tableView)
        borderedContainer.addSubview(errorView)

        tableView.refreshControl = refreshControl

        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Bordered container
            borderedContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            borderedContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            borderedContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            borderedContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: borderedContainer.topAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: borderedContainer.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: borderedContainer.trailingAnchor, constant: -16),

            // Subtitle divider
            subtitleDivider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            subtitleDivider.leadingAnchor.constraint(equalTo: borderedContainer.leadingAnchor),
            subtitleDivider.trailingAnchor.constraint(equalTo: borderedContainer.trailingAnchor),
            subtitleDivider.heightAnchor.constraint(equalToConstant: 1),

            // Table view
            tableView.topAnchor.constraint(equalTo: subtitleDivider.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: borderedContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: borderedContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: borderedContainer.bottomAnchor),

            // Error view centered in table area
            errorView.topAnchor.constraint(equalTo: tableView.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: borderedContainer.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: borderedContainer.trailingAnchor),
        ])
    }

    // MARK: - Rx Bindings
    private func bindViewModel() {
        // Data source
        let dataSource = RxTableViewSectionedReloadDataSource<CatSectionModel>(
            configureCell: { [weak self] _, tableView, indexPath, item in
                guard let self else { return UITableViewCell() }
                switch item {
                case .breed(let model):
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: CatBreedCell.reuseIdentifier,
                        for: indexPath
                    ) as! CatBreedCell
                    cell.configure(with: model)
                    cell.onToggleExpand = { [weak self] in
                        guard let self else { return }
                        let current = self.viewState.expandedBreedId.value
                        self.viewState.expandedBreedId.accept(
                            current == model.breed.id ? nil : model.breed.id
                        )
                    }
                    return cell
                case .loading:
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: LoadingFooterCell.reuseIdentifier,
                        for: indexPath
                    ) as! LoadingFooterCell
                    cell.startAnimation()
                    return cell
                case .error(let state):
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: InlineErrorCell.reuseIdentifier,
                        for: indexPath
                    ) as! InlineErrorCell
                    cell.configure(state: state) { [weak self] in
                        guard let self else { return }
                        Task { await self.interactor.fetchBreeds() }
                    }
                    return cell
                }
            }
        )

        // Combine all state into section models
        Observable.combineLatest(
            viewState.breeds.asObservable(),
            viewState.expandedBreedId.asObservable().distinctUntilChanged(),
            viewState.isLoading.asObservable().distinctUntilChanged(),
            viewState.errorState.asObservable().distinctUntilChanged()
        )
        .map { breeds, expandedId, isLoading, errorState -> [CatSectionModel] in
            var items: [CatListItem] = breeds.values.map { breed in
                .breed(CatBreedCellModel(
                    breed: breed,
                    isExpanded: breed.id == expandedId
                ))
            }

            if !breeds.isEmpty {
                if errorState != .noError {
                    items.append(.error(errorState))
                } else if isLoading {
                    items.append(.loading)
                }
            }

            return [CatSectionModel(items: items)]
        }
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)

        // Skeleton: show when loading AND breeds empty AND no error
        Observable.combineLatest(
            viewState.isLoading.asObservable(),
            viewState.breeds.asObservable(),
            viewState.errorState.asObservable()
        )
        .map { isLoading, breeds, errorState in
            isLoading && breeds.isEmpty && errorState == .noError
        }
        .distinctUntilChanged()
        .subscribe(onNext: { [weak self] showSkeleton in
            guard let self else { return }
            if showSkeleton {
                let gradient = SkeletonGradient(
                    baseColor: UIColor(DSColor.gray4),
                    secondaryColor: UIColor(DSColor.gray5)
                )
                self.tableView.showAnimatedGradientSkeleton(
                    usingGradient: gradient,
                    transition: .crossDissolve(0.25)
                )
            } else {
                self.tableView.hideSkeleton(transition: .crossDissolve(0.25))
            }
        })
        .disposed(by: disposeBag)

        // Error view: show when error AND breeds empty
        Observable.combineLatest(
            viewState.errorState.asObservable().distinctUntilChanged(),
            viewState.breeds.asObservable()
        )
        .subscribe(onNext: { [weak self] errorState, breeds in
            guard let self else { return }
            let showError = errorState != .noError && breeds.isEmpty
            self.errorView.isHidden = !showError

            if showError {
                self.errorView.configure(state: errorState) { [weak self] in
                    guard let self else { return }
                    Task { await self.interactor.fetchBreeds() }
                }
            }
        })
        .disposed(by: disposeBag)

        // Pagination: trigger fetch when last breed item appears
        tableView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] _, indexPath in
                guard let self else { return }
                let breedsCount = self.viewState.breeds.value.count
                if breedsCount > 0 && indexPath.row == breedsCount - 1 && self.viewState.errorState.value == .noError {
                    Task { await self.interactor.fetchBreeds() }
                }
            })
            .disposed(by: disposeBag)

        // Pull-to-refresh with minimum delay
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                Task {
                    async let refresh: Void = self.interactor.refreshBreeds()
                    async let delay: Void = Task.sleep(nanoseconds: 800_000_000)
                    _ = try? await (refresh, delay)
                    self.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
}
