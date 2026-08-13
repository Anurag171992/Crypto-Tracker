# Crypto Tracker

## Overview

Crypto Tracker is an iOS application built using **SwiftUI** and the **MVVM** architecture.

The application fetches real-time cryptocurrency market data and allows users to search, monitor, and manage their crypto portfolio. The project focuses on clean architecture, modern Swift development practices, and reactive programming using Combine.

---

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture.

This structure promotes separation of concerns, improves maintainability, and makes the application easier to test.

- **Model**
- **View**
- **ViewModel**
- **Services**

---

## Technical Highlights

### SwiftUI
Declarative UI built entirely with SwiftUI.

### Combine
Used for:
- Fetching API data
- Search functionality
- State management
- Reactive UI updates

### Core Data
Portfolio persistence across app launches.

### Generic Networking Layer
Reusable networking layer to fetch and decode any `Decodable` model.

### Dependency Injection
Injected dependencies for modularity and testability.

---

## Planned Screens

- Home
- Portfolio
- Coin Details
- Settings

---

## Project Structure

- **Core**
  - **Components**  
    Reusable SwiftUI views shared across the app.  
  - **Detail**  
    Coin detail feature, organized into Model, View, and ViewModel.  
  - **Home**  
    Home screen feature, also split into Model, View, and ViewModel.  

- **Helper**  
  Utility helpers for common tasks and app-wide support functions.  

- **Main**  
  Application entry point and lifecycle management.  

- **Services**
  - **Endpoints**  
    Defines API endpoints for cryptocurrency data.  
  - **Manager**  
    Networking and service managers to handle requests.  
  - **Service**  
    Core networking logic and reusable API layer.  

- **Utilities**
  - **Constants**  
    Centralized app-wide constant values.  
  - **Extension**  
    Swift extensions for reusable functionality.  
  - **Resources**  
    Assets, themes, and configuration files.  

- **Info.plist**  
  Supporting configuration for the application.  

---
## 🛠 Technologies

- **[SwiftUI](ca://s?q=Learn_about_SwiftUI)** → Declarative UI framework for building modern iOS apps  
- **[MVVM](ca://s?q=Explain_MVVM_architecture)** → Clean separation of concerns with Model, View, and ViewModel layers  
- **[Combine](ca://s?q=What_is_Combine_in_Swift)** → Reactive programming for data streams and UI updates  
- **[Core Data](ca://s?q=Core_Data_in_Swift)** → Local persistence for portfolio and offline support  
- **[URLSession](ca://s?q=URLSession_in_Swift)** → Networking layer for API requests  

---

## ⚙️ Requirements

- **Xcode 16+** → Latest IDE with SwiftUI/SwiftData support  
- **iOS 17+** → Minimum deployment target  
- **Swift 6** → Language version  

---

## 📸 Screenshots

<table>
  <tr>
    <td align="center">
      <img src="Screenshots/Launch Screen.png" alt="Launch Screen" width="250"/><br/>
      Launch Screen
    </td>
    <td align="center">
      <img src="Screenshots/HomeView.png" alt="Home View" width="250"/><br/>
      Home View
    </td>
    <td align="center">
      <img src="Screenshots/Refresh.png" alt="Refresh" width="250"/><br/>
      Refresh
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="Screenshots/PortfolioView.png" alt="Portfolio View" width="250"/><br/>
      Portfolio View
    </td>
    <td align="center">
      <img src="Screenshots/EditPortfolioView.png" alt="Edit Portfolio View" width="250"/><br/>
      Edit Portfolio View
    </td>
    <td align="center">
      <img src="Screenshots/AddCoinValue.png" alt="Add Coin Value" width="250"/><br/>
      Add Coin Value
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="Screenshots/SettingsView.png" alt="Settings View" width="250"/><br/>
      Settings View
    </td>
  </tr>
</table>

---

## 🗺 Roadmap

- ✅ Custom Launch screen.
- ✅ Market screen  
- ✅ Search coins using Combine  
- ✅ Pull to refresh with haptic feedback  
- ✅ Coin detail screen  
- ✅ 7-day price chart  
- ✅ Portfolio  
- ✅ Add coins to portfolio  
- ✅ Edit portfolio holdings  
- ✅ Core Data persistence  
- ✅ Offline support for added portfolio coins 
- ✅ Image caching  
- ✅ Dark Mode  
- ✅ Settings page  

---

## 📝 Notes

To run this project successfully, you need to configure the **CoinGecko API**:

1. Go to [CoinGecko API](https://www.coingecko.com/en/api) and sign up for a free account.  
2. Generate your API key from the developer dashboard.  
3. Create a `Secrets.xcconfig` file in your project (do not commit this file to GitHub).  
4. Add your API key inside **Secrets.xcconfig**:
   ```text
   COINGECKO_API_KEY = your_api_key_here

---

## 👨‍💻 Author

Developed by **Anurag**  
🔗 [Connect on LinkedIn](https://www.linkedin.com/in/anurag-kashyap-2a1b22a0/)


