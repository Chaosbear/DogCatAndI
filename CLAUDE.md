# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
# Build
xcodebuild build -scheme dogCatAndI -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -quiet

# Run all tests (unit + UI)
xcodebuild test -scheme dogCatAndI -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -quiet

# Run a single test class
xcodebuild test -scheme dogCatAndI -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:dogCatAndITests/DogsInteractorTests -quiet

# Run a single test method
xcodebuild test -scheme dogCatAndI -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:dogCatAndITests/DogsInteractorTests/testFetchDogsConcurrently_callsWorkerThreeTimes -quiet
```

## Swift Compiler Settings

- **`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`** — all types default to `@MainActor`. Nonisolated code must be explicitly marked.
- **`SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY = YES`** — types from transitive imports are not visible. You must explicitly `import` every module you reference (e.g., `import Combine` for `ObservableObject`, `import OrderedCollections` for `OrderedDictionary`, `import Alamofire` for `HTTPMethod`/`Parameters`).
- **`PBXFileSystemSynchronizedRootGroup`** — files added to disk are auto-synced to the Xcode project; no manual project file edits needed.

## Architecture: Clean Swift VIP with SwiftUI

Each feature scene (Dogs, Cats, Me) follows this pattern:

```
View (SwiftUI) ──observes──▶ ViewState (@MainActor ObservableObject)
     │                              ▲
     │ calls                        │ updates
     ▼                              │
Interactor ──────▶ Presenter ───────┘
     │
     ▼
   Worker ──▶ NetworkService (Alamofire)
```

**Component roles:**
- **ViewState** (`DogsViewState`, `CatsViewState`, `MeViewState`) — `@MainActor` `ObservableObject` with `@Published` properties. The view observes it via `@ObservedObject`.
- **Presenter** (protocol: `*PresentationLogic`) — transforms Response models into ViewModels, updates ViewState directly (no `DispatchQueue.main.async` needed since everything is `@MainActor`).
- **Interactor** (protocol: `*BusinessLogic`) — orchestrates business logic, calls Worker, passes Response to Presenter. Uses `async/await`.
- **Worker** (protocol: `*WorkerProtocol`) — thin wrapper around `NetworkServiceProtocol` calls.

**Dependency wiring:** `AppContainer` (`Feature/_RootView/AppContainer.swift`) creates and wires all VIP components with manual constructor injection. `RootView` owns it as `@StateObject`.

**Models:** Nested enums per scene (`Dogs.FetchDogs.Request/Response/ViewModel`) in `Core/Model/`.

## Key Directory Layout

```
dogCatAndI/
├── Feature/
│   ├── _RootView/          # AppContainer (DI), RootView (TabView)
│   ├── Dogs/               # Interactor, Presenter, View, CardView
│   ├── Cats/               # Interactor, Presenter, View, CardView
│   └── Me/                 # Interactor, Presenter, View
├── Core/
│   ├── Model/              # VIP models + API response models
│   ├── Network/            # NetworkService (Alamofire), NetworkMonitor
│   ├── Worker/             # DogsWorker, CatsWorker, MeWorker
│   ├── DesignSystem/       # DSFont, DSColor
│   ├── UIComponent/        # ErrorView, SkeletonView, Shimmer, NavBar, TabBar
│   ├── Extension/          # String, Color, Font, View extensions
│   └── Utility/            # Utils (date formatting, etc.)
├── Config/                 # Dev/UAT/Prod xcconfig + AppConfig.swift
dogCatAndITests/
├── Mocks/                  # MockPresenters, MockWorkers, MockNetworkService
├── *InteractorTests.swift
└── *PresenterTests.swift
```

## Testing Patterns

- **Interactor tests** inject mock Workers and mock Presenters, then assert call counts and arguments on the mocks.
- **Presenter tests** create a real ViewState, call presenter methods, then assert ViewState properties. Some use `RunLoop.current.run(until:)` to process updates; others use `DispatchQueue.main.asyncAfter` with `XCTestExpectation`.
- Test classes that instantiate `@MainActor` ViewState objects must themselves be annotated `@MainActor`.
- Async interactor methods are invoked via `Task { await sut.fetchBreeds() }` followed by an expectation wait.

## Dependencies (SPM)

- **Alamofire** — HTTP networking (`NetworkServiceProtocol` uses `HTTPMethod`, `Parameters`, `ParameterEncoding`)
- **swift-collections** — `OrderedDictionary` for cats breed list (preserves insertion order with key-based access)
- **netfox** — network debugging (enabled in DEBUG builds)

## Multi-Environment Config

Base URLs (`DOG_URL`, `CAT_URL`, `ME_URL`) and `APP_ENV` are defined in xcconfig files (`Config/DevConfig.xcconfig`, `UATConfig.xcconfig`, `ProdConfig.xcconfig`) and loaded at runtime via `Config.getConfigValue(key:)` from `Info.plist`.
