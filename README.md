# Crypto Tracker

## Overview

Crypto Tracker is an iOS application built using **SwiftUI** and the **MVVM** architecture.

The application fetches real-time cryptocurrency market data and allows users to search, monitor, and manage their crypto portfolio. The project focuses on clean architecture, modern Swift development practices, and reactive programming using Combine.

---

## Planned Features

- Display live cryptocurrency market data
- Search coins using Combine
- Coin detail screen
- Interactive 7-day price chart
- Portfolio management
- Add and remove coins from portfolio
- Persist portfolio locally using Core Data
- Settings screen
- Offline support
- Pull-to-refresh
- Dark Mode support

---

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture.

This structure promotes separation of concerns, improves maintainability, and makes the application easier to test.

- **Model**
  - Coin
  - Market Data
  - Statistics
  - Portfolio Entity (Core Data)

- **View**
  - Home
  - Portfolio
  - Coin Details
  - Settings

- **ViewModel**
  - HomeViewModel
  - DetailViewModel
  - PortfolioViewModel

- **Services**
  - Networking
  - Coin Data Service
  - Market Data Service
  - Portfolio Data Service
  - Image Cache Service

---

## Technical Highlights

### SwiftUI

The entire user interface is built using SwiftUI with a declarative approach.

### Combine

Combine is used for:

- Fetching API data
- Search functionality
- State management
- Reactive UI updates

### Core Data

Core Data is used to persist the user's portfolio locally, allowing portfolio information to remain available between app launches.

### Generic Networking Layer

A reusable networking layer is used to fetch and decode any `Decodable` model.

### Dependency Injection

Dependencies are injected where required to improve modularity and testability.

---

## Planned Screens

- Home
- Portfolio
- Coin Details
- Settings

---

## Project Structure

- **App** — App entry point
- **Core** — Networking, Utilities, Extensions
- **Models** — API and local models
- **Services** — API services, Image service, Portfolio service
- **ViewModels** — Business logic
- **Views**
  - Home
  - Portfolio
  - Coin Detail
  - Settings
  - Components
- **Resources**
  - Assets
  - Preview Content

---

## Technologies

- SwiftUI
- MVVM
- Combine
- Core Data
- URLSession
- Async Image Caching
- Swift Concurrency (where applicable)

---

## Requirements

- Xcode 16+
- iOS 17+
- Swift 6

---

## Screenshots

Screenshots will be added once the application is feature complete.

---

## Roadmap

- [ ] Market screen
- [ ] Search coins using Combine
- [ ] Coin detail screen
- [ ] 7-day price chart
- [ ] Portfolio
- [ ] Add coins to portfolio
- [ ] Edit portfolio holdings
- [ ] Core Data persistence
- [ ] Settings page
- [ ] Offline support
- [ ] Image caching
- [ ] Dark Mode
- [ ] Performance optimizations

---

## Notes

This project is currently under active development.

The primary objective is to build a production-style cryptocurrency tracker while following clean architecture principles and modern iOS development practices.

---

## Author

Developed by **Anurag**.
