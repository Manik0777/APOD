Author : Manik Mathesh
Date : Oct 2025

NASA APOD Viewer
================
- A Swift-based iOS application that fetches and displays NASA's Astronomy Picture of the Day (APOD).
- It supports offline caching, image loading, fallback handling, and a clean user experience with modern iOS features.

Setup Notes
============
If you encounter build issues related to a missing Swift Package called `AppInjection`, it's likely due to leftover references in the project settings.

To fix this:
- Open your project in Xcode
- Go to **Build Phases > Link Binary With Libraries**
- Remove any lingering reference to `AppInjection.framework`
- Clean the build folder (`Shift + Cmd + K`) and rebuild

This package was previously used but has been removed. If you're starting fresh, you won't need it.

 
Features Implemented:
=====================
- Fetches APOD data from NASA's public API
- Displays image, title, and explanation for each day
- Caches APOD data locally using Core Data
- Loads image data from disk or cache when available
- Detects fallback when today's APOD is not returned
- Pull-to-refresh support for reloading today's APOD
- Toast-style message display for user feedback
- Native dark mode support (automatic via system appearance)
- Partial layout support for iPad devices

Technologies & Skills Used
==========================

- Category          Tools / Concepts
- Language          Swift
- Architecture      MVVM (Model-View-ViewModel)
- Concurrency       Swift Concurrency (async/await), @MainActor
- Networking        URLSession, NASA APOD API
- Persistence       Core Data (with in-memory store for testing)
- Caching           Image caching with disk fallback
- UI Components     SwiftUI, Refreshable, Toast, @Published
- Testing           XCTest, mock API injection, in-memory Core Data
- Dependency design Protocol-oriented programming, dependency injection
- Utilities         Date formatting, constants management
- Platform Support  iPhone (full), iPad (partial), dark mode
- Modularization    Separate modules: Model, Repository, APIClient, CoreUtils

Project Structure
==================

Code
NASA-APOD/
├── Model/           # Data models (APOD, media types)
├── Repository/      # Core Data logic, APODRepository implementation
├── APIClient/       # API calls to NASA
├── CoreUtils/       # Shared utilities (formatters, constants)
├── UI/              # SwiftUI, UIKit views and view models
├── Tests/           # Unit tests with mocks and in-memory Core Data

Running Tests
==============

- Tests are written using XCTest and use an in-memory Core Data stack to avoid disk writes. To run tests:
- Open the project in Xcode
- Select the test target
- Press ⌘U to run all tests

API Key
========
- NASA provides a demo API key (DEMO_KEY) for public use. For production, you can register for your own key at api.nasa.gov.
