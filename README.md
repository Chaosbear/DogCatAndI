# Dog + Cat & I

An iOS app built with **SwiftUI** and **Clean Swift VIP architecture** that showcases three features across a tabbed interface: browsing random dog images, exploring cat breeds, and viewing random user profiles.

## Features

### Dogs
- Fetches 3 random dog images per load from the [Dog CEO API](https://dog.ceo/dog-api/)
- Two loading strategies: **Concurrent** (parallel with `TaskGroup`) and **Sequential** (one-by-one with delays)
- Adaptive grid layout with timestamped labels

### Cats
- Paginated list of cat breeds from the [Cat Facts API](https://catfact.ninja/)
- Expandable breed cards showing country, origin, coat type, and pattern
- Infinite scroll with pull-to-refresh

### Me
- Displays a random user profile from the [Random User API](https://randomuser.me/)
- Shows avatar, name, date of birth, gender, nationality, phone, and address
- Reload button to fetch a new profile

All tabs include skeleton loading with shimmer animations, network error detection, and retry capability.

## Getting Started

1. Clone the repository
2. Open `dogCatAndI.xcodeproj` in Xcode
3. Dependencies are managed via **Swift Package Manager** and resolve automatically
4. Select a simulator and run (Cmd+R)

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [Alamofire](https://github.com/Alamofire/Alamofire) | 5.11.1+ | HTTP networking |
| [swift-collections](https://github.com/apple/swift-collections) | 1.3.0+ | `OrderedDictionary` for ordered breed storage |
| [netfox](https://github.com/kasketis/netfox) | 1.21.0+ | Network debugging (DEBUG builds) |

## Architecture

The app follows **Clean Swift VIP** adapted for SwiftUI:

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

- **ViewState** — `@MainActor ObservableObject` with `@Published` properties observed by the view
- **Interactor** — orchestrates business logic using `async/await`
- **Presenter** — transforms Response models into ViewModels and updates ViewState
- **Worker** — thin networking wrapper around `NetworkServiceProtocol`
- **AppContainer** — manual constructor injection wiring all VIP components

## Project Structure

```
dogCatAndI/
├── Feature/
│   ├── _RootView/       # AppContainer (DI), RootView (TabView)
│   ├── Dogs/            # Interactor, Presenter, View, CardView
│   ├── Cats/            # Interactor, Presenter, View, CardView
│   └── Me/              # Interactor, Presenter, View
├── Core/
│   ├── Model/           # VIP request/response/viewmodel models + API models
│   ├── Network/         # NetworkService (Alamofire), NetworkMonitor
│   ├── Worker/          # DogsWorker, CatsWorker, MeWorker
│   ├── DesignSystem/    # DSFont, DSColor
│   ├── UIComponent/     # ErrorView, SkeletonView, Shimmer, NavBar, TabBar
│   ├── Extension/       # String, Color, Font, View extensions
│   └── Utility/         # Date formatting helpers
├── Config/              # Dev/UAT/Prod xcconfig + AppConfig.swift
dogCatAndITests/         # Unit tests (Interactor + Presenter) with mocks
dogCatAndIUITests/       # UI tests
```

## Multi-Environment Config

Base URLs are defined in xcconfig files and loaded at runtime from `Info.plist`:

| Environment | Config File |
|-------------|-------------|
| Development | `Config/DevConfig.xcconfig` |
| UAT | `Config/UATConfig.xcconfig` |
| Production | `Config/ProdConfig.xcconfig` |

## Testing

```bash
# Run all tests
xcodebuild test -scheme dogCatAndI -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -quiet

# Run a single test class
xcodebuild test -scheme dogCatAndI -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:dogCatAndITests/DogsInteractorTests -quiet

# Run a single test method
xcodebuild test -scheme dogCatAndI -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:dogCatAndITests/DogsInteractorTests/testFetchDogsConcurrently_callsWorkerThreeTimes -quiet
```

Tests follow these patterns:
- **Interactor tests** — inject mock Workers and Presenters, assert call counts and arguments
- **Presenter tests** — use real ViewState, assert `@Published` property updates
