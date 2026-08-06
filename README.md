# GitHub Repository Viewer

## Overview

GitHub Repository Viewer is an iOS application built using UIKit and the MVVM architecture. 
The application retrieves public repositories for a GitHub user and displays their details, including the latest commit information for each repository.

The project demonstrates modern Swift concurrency using Async/Await and TaskGroup while maintaining a clean and modular architecture.

---

## Features

- Display GitHub repositories for a user.
- Show repository name, description and programming language.
- Display stars and forks count.
- Fetch the latest commit for every repository.
- Concurrent commit fetching using TaskGroup.
- Generic networking layer.
- MVVM architecture.
- Dependency Injection.
- Activity indicator while fetching data.
- Smooth animations when latest commit data updates - transitionCrossDissolve

---

## Project Structure
- **ApplicationMain**: AppDelegate, SceneDelegate  
- **Module/Repository**: Model, View, ViewModel  
- **Networking**: NetworkManager, APIError, Endpoint abstraction  
- **Resources**: Config (Secrets), Assets  
- **Storyboard**: LaunchScreen, Main  
- **Utilities**: App‑wide constants, ReusableAlert, Extension

---

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture.
This modular structure ensures separation of concerns and makes the app maintainable.

- **Model**
  - Repository
  - Commit

- **View**
  - RepositoryListViewController
  - UITableView

- **ViewModel**
  - RepositoryListViewModel

- **Networking**
  - Protocol-oriented networking
  - Generic NetworkManager
  - Endpoint abstraction
  - RepositoryEndpoint

---

## Technical Decisions

### Async/Await

The project uses Swift's async/await API to simplify asynchronous networking and improve code readability.

### TaskGroup

Latest commits for repositories are fetched concurrently using "withTaskGroup".
This reduces the overall loading time because commit requests are independent of each other.

### Generic Networking Layer

A single generic networking method is used for decoding any "Decodable" model.

### Dependency Injection

The ViewModel receives its networking dependency through its initializer making the code easier to test and maintain.

### Sendable Models

All models conform to "Sendable" to ensure thread safety when used with Swift Concurrency.

---

## Error Handling

The application handles the following scenarios:

- Invalid URL
- Invalid server response
- JSON decoding failure
- Empty repositories (HTTP 409)

If a repository has no commits, the UI displays an appropriate placeholder instead of failing.

---

## Setup

### Step 1

Open the included **Secrets.xcconfig** file in the Resources/Config folder.  
Replace the placeholder with your own GitHub personal access token.

ACCESS_TOKEN = your_github_personal_access_token

In your **Info.plist**, ensure the following placeholder key is present:

<key>AccessToken</key>
<string>$(ACCESS_TOKEN)</string>

#Notes
Access token is not included in the project ZIP for security reasons. 
Please add your own token in Secrets.xcconfig before running.
This ensures sensitive credentials are never shared keeping the project secure.

### Step 2

Run the project.

---

## Requirements

- Xcode 16+
- iOS 15+
- Swift 6

---

## Screenshots

The following images demonstrate the app's UI support for both light and dark modes.

<div align="center">

<table>
<tr>
<td align="center">
<b>Launch Screen</b><br><br>
<img src="Screenshots/LaunchScreen.png" width="250"/>
</td>

<td align="center">
<b>Loading Screen</b><br><br>
<img src="Screenshots/Loading.png" width="250"/>
</td>
</tr>

<tr>
<td align="center">
<b>Repository List (Light Mode)</b><br><br>
<img src="Screenshots/ListLight.png" width="250"/>
</td>

<td align="center">
<b>Repository List (Dark Mode)</b><br><br>
<img src="Screenshots/ListDark.png" width="250"/>
</td>
</tr>

<tr>
<td align="center">
<b>Error State</b><br><br>
<img src="Screenshots/Error.png" width="250"/>
</td>

<td align="center">
<b>Retry State (Light Mode)</b><br><br>
<img src="Screenshots/RetryLight.png" width="250"/>
</td>
</tr>

<tr>
<td align="center">
<b>Retry State (Dark Mode)</b><br><br>
<img src="Screenshots/RetryDark.png" width="250"/>
</td>

<td></td>
</tr>
</table>

</div>


## Notes
- The launch screen includes the app icon and company name.
- The app icon was generated online as a placeholder.
- Screenshots demonstrate both light and dark mode support.

---

## Author

Developed by **Anurag** as part of an iOS technical assessment for Scalable Capital.
