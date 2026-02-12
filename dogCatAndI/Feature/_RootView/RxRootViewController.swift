//
//  RxRootViewController.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 10/2/2569 BE.
//

import UIKit

final class RxRootViewController: UIViewController {
    // MARK: - Type
    enum Tab: Int, CaseIterable {
        case dogs = 0
        case cats = 1
        case me = 2

        var title: String {
            switch self {
            case .dogs: "Dogs"
            case .cats: "cats"
            case .me: "Me"
            }
        }

        var image: String {
            switch self {
            case .dogs: "ic_dog"
            case .cats: "ic_cat"
            case .me: "ic_profile"
            }
        }
    }

    // MARK: - Property
    private let container: RxAppContainer
    private var selectedTab: Tab = .dogs

    // MARK: - UI Components
    private let navBar: CustomNavBarUIView

    private let tabBarVC: UITabBarController = {
        let tabBar = UITabBarController()
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()

    private let tabBar: CustomTabbarUIView

    // MARK: - Init
    init(container: RxAppContainer = RxAppContainer()) {
        self.container = container

        // Leading icon
        let leadingIcon = UIImageView(image: UIImage(named: "ic_dog_n_cat")?.withRenderingMode(.alwaysTemplate))
        leadingIcon.tintColor = UIColor(DSColor.secondaryBlue)
        leadingIcon.contentMode = .scaleAspectFit
        leadingIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingIcon.widthAnchor.constraint(equalToConstant: 56),
            leadingIcon.heightAnchor.constraint(equalToConstant: 56),
        ])

        // Trailing icon
        let trailingIcon = UIImageView(image: UIImage(named: "ic_account")?.withRenderingMode(.alwaysTemplate))
        trailingIcon.tintColor = UIColor(DSColor.black)
        trailingIcon.contentMode = .scaleAspectFit
        trailingIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailingIcon.widthAnchor.constraint(equalToConstant: 56),
            trailingIcon.heightAnchor.constraint(equalToConstant: 56),
        ])

        // Nav bar
        self.navBar = CustomNavBarUIView(
            title: "Dog + Cat & I",
            titleFont: DSFont.h3.uifont,
            barHeight: 64,
            leadingView: leadingIcon,
            trailingView: trailingIcon
        )

        // Tab bar
        self.tabBar = CustomTabbarUIView(
            tabs: Tab.allCases.map { tab in
                CustomTabbarItem(id: tab.title, title: tab.title, image: tab.image)
            }
        )

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setupLayout()

        tabBar.onTabSelected = { [weak self] index in
            guard let self, let tab = Tab(rawValue: index) else { return }
            self.switchToTab(tab)
        }

        switchToTab(.dogs)
    }

    // MARK: - Layout
    private func setUp() {
        view.backgroundColor = UIColor(DSColor.primaryWhite)
        
        addChild(tabBarVC)
        view.addSubview(tabBarVC.view)
        tabBarVC.didMove(toParent: self)
        let viewControllers: [UIViewController] = [
            container.dogsViewController,
            container.catsViewController,
            container.meViewController
        ]
        tabBarVC.setViewControllers(viewControllers, animated: false)
        if #available(iOS 18.0, *) {
            tabBarVC.setTabBarHidden(true, animated: false)
        } else {
            container.dogsViewController.tabBarController?.tabBar.isHidden = true
            container.catsViewController.tabBarController?.tabBar.isHidden = true
            container.meViewController.tabBarController?.tabBar.isHidden = true
        }

        view.addSubview(navBar)
        view.addSubview(tabBar)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Nav bar at top of safe area
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // Content area between nav bar and tab bar
            tabBarVC.view.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tabBarVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarVC.view.bottomAnchor.constraint(equalTo: tabBar.topAnchor),

            // Tab bar at bottom of safe area
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    // MARK: - Tab Switching
    private func switchToTab(_ tab: Tab) {
        guard let count = tabBarVC.viewControllers?.count, tab.rawValue < count else { return}
        selectedTab = tab
        tabBarVC.selectedIndex = tab.rawValue
        tabBar.selectTab(at: tab.rawValue)
    }
}
