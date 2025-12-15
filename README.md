# Task Systems

A Flutter e-commerce application built with **Clean Architecture** principles, featuring product listing, pagination, favorites management, and offline support.

---

## 📱 Overview

`task_systems` is a Flutter project that demonstrates best practices in mobile app development:

- **Clean Architecture** with clear separation of concerns
- **GetX** for state management and dependency injection
- **Pagination** with infinite scroll
- **Offline support** with local caching
- **Favorites management** with persistent storage
- **Comprehensive unit testing**

---

## ✨ Features

- 📦 **Product Listing**: Browse products with pagination
- 🔄 **Infinite Scroll**: Automatically loads more products as you scroll
- ⭐ **Favorites**: Mark products as favorites with persistent storage
- 📱 **Product Details**: View detailed information about each product
- 🌐 **Offline Support**: Cached data available when offline
- 🎨 **Modern UI**: Material Design 3 with dark mode support
- 🧪 **Well Tested**: Comprehensive unit tests for data sources and repositories

---

## 🏗 Architecture

The project follows **Clean Architecture** with three main layers:

```
lib/
│
├── core/                          # Shared utilities and infrastructure
│   ├── controllers/               # Base controllers
│   ├── error/                     # Error handling (exceptions, failures)
│   ├── network/                   # Network configuration (Dio, interceptors)
│   ├── style/                     # App-wide styling
│   ├── usecase/                   # Base use case classes
│   └── widgets/                   # Reusable widgets
│
├── features/
│   └── products/                  # Products feature module
│       ├── data/                  # Data Layer
│       │   ├── data_source/       # Remote & Local data sources
│       │   ├── model/              # Data models (ProductModel)
│       │   └── repositories/       # Repository implementations
│       │
│       ├── domain/                 # Domain Layer (Business Logic)
│       │   ├── entities/           # Business entities (Product)
│       │   ├── repositories/       # Repository interfaces
│       │   └── usecase/            # Use cases (GetProducts, etc.)
│       │
│       └── presentation/           # Presentation Layer
│           ├── controller/         # GetX controllers
│           └── ui/                 # UI pages and widgets
│
└── main.dart                       # App entry point
```

### Layer Responsibilities

- **Domain Layer**: Contains business logic, entities, and use cases (framework-independent)
- **Data Layer**: Handles API calls, local storage, and data models
- **Presentation Layer**: UI components and state management

### Why Clean Architecture?

- ✅ **Testability**: Business logic is isolated and easily testable
- ✅ **Maintainability**: Clear separation makes code easier to understand and modify
- ✅ **Scalability**: Easy to add new features without affecting existing code
- ✅ **Independence**: Business logic is independent of frameworks and UI

---

## 🔄 State Management

The project uses **GetX** for state management and dependency injection.

**GetX Features Used:**
- `GetX` controllers for state management
- `Obx` for reactive UI updates
- `Get.find()` for dependency injection
- Route management with `Get.toNamed()`

**Advantages:**
- Simple and intuitive API
- Excellent performance
- Built-in dependency injection
- Less boilerplate code

---

## 📡 API Integration

### Remote Data Source
- Uses **Dio** for HTTP requests
- Base URL: `https://fakestoreapi.com`
- Custom interceptors for error handling
- Query parameters for pagination (`limit`)

### Pagination Implementation
- **Limit-based pagination**: Incrementally increases limit to fetch more items
- **Infinite scroll**: Automatically loads more when scrolling near the end
- **Smart deduplication**: Prevents duplicate items when loading more
- **Loading states**: Shows loading indicators during data fetching

### Local Data Source
- Uses **Hive** for local storage
- Caches products for offline access
- Stores favorites persistently
- Automatic fallback to cache on network errors

---

## 🧪 Testing

The project includes comprehensive unit tests using **mocktail** for mocking.

### Test Coverage

**Data Source Tests** (`products_remote_data_source_impl_test.dart`):
- ✅ Successful API calls with correct parameters
- ✅ Error handling (ServerException, custom exceptions)
- ✅ Data parsing and model conversion

**Repository Tests** (`products_repository_impl_test.dart`):
- ✅ Successful data fetching and caching
- ✅ Offline fallback to cached data
- ✅ Error handling (NetworkFailure, ServerFailure, CacheFailure)
- ✅ Pagination with different limit values

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/products/data/data_source/products_remote_data_source_impl_test.dart

# Run tests with coverage
flutter test --coverage
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- iOS Simulator / Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd task_systems
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Initialize Hive** (for local storage)
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 📦 Dependencies

### Main Dependencies
- **get**: ^4.6.6 - State management and dependency injection
- **dio**: ^5.7.0 - HTTP client for API calls
- **dartz**: ^0.10.1 - Functional programming (Either, Failure)
- **equatable**: ^2.0.5 - Value equality for entities
- **connectivity_plus**: ^6.0.5 - Network connectivity checking
- **hive**: ^2.2.3 - Fast, lightweight NoSQL database
- **hive_flutter**: ^1.1.0 - Hive integration for Flutter
- **cached_network_image**: ^3.4.1 - Cached network images

### Dev Dependencies
- **flutter_test**: SDK - Testing framework
- **mocktail**: ^1.0.4 - Mocking library for tests
- **hive_test**: ^1.0.1 - Hive testing utilities
- **build_runner**: ^2.4.12 - Code generation

---

## 🎯 Key Features Explained

### Pagination
The app implements limit-based pagination:
- Initial load: 10 products
- Each "load more": Adds 10 more products
- Automatically triggers when user scrolls near the bottom
- Prevents duplicate items
- Shows loading indicator during fetch

### Favorites
- Tap to toggle favorite status
- Persisted locally using Hive
- Available offline
- Visual indicator on product cards

### Offline Support
- Products are cached after first successful fetch
- Automatically falls back to cache on network errors
- Seamless user experience even without internet

---

## 🛠 Project Structure Details

### Core Module
Contains shared functionality used across the app:
- Error handling (exceptions and failures)
- Network configuration and interceptors
- Base controllers and use cases
- Reusable widgets

### Products Feature
Complete feature module demonstrating Clean Architecture:

**Domain Layer:**
- `Product` entity (business object)
- `ProductsRepository` interface
- Use cases: `GetProducts`, `GetProductDetails`, `ToggleFavorite`, etc.

**Data Layer:**
- `ProductsRemoteDataSource` - API communication
- `ProductsLocalDataSource` - Local storage (Hive)
- `ProductModel` - Data model extending Product entity
- `ProductsRepositoryImpl` - Repository implementation

**Presentation Layer:**
- `ProductsController` - State management for products list
- `ProductDetailsController` - State management for product details
- `ProductsPage` - Products listing UI
- `ProductDetailsPage` - Product details UI
- `ProductCard` - Reusable product card widget

---

## 🔧 Configuration

### API Configuration
The API base URL is configured in `lib/core/network/dio_client.dart`:
```dart
baseUrl: 'https://fakestoreapi.com'
```

### Pagination Settings
Pagination page size is configured in `ProductsController`:
```dart
final int _pageSize = 10;
```

---

## 📝 Code Style

The project follows:
- **Dart style guide** conventions
- **Clean code** principles
- **SOLID** principles
- Meaningful variable and function names
- Comprehensive error handling
- Proper separation of concerns

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: Hive boxes not initialized
```bash
# Solution: Run build_runner
flutter packages pub run build_runner build
```

**Issue**: Build errors after dependency changes
```bash
# Solution: Clean and rebuild
flutter clean
flutter pub get
flutter run
```

**Issue**: Tests failing
```bash
# Solution: Ensure all dependencies are installed
flutter pub get
flutter test
```

---

## 📄 License

This project is for educational purposes.

---

## 👨‍💻 Author

Flutter Developer  
Clean Architecture • GetX • Testing • Pagination

---

## 🙏 Acknowledgments

- [Fake Store API](https://fakestoreapi.com) for providing the test API
- Flutter community for excellent packages and resources
