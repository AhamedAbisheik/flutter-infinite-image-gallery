
# Infinite Image Gallery

A production-style Flutter image gallery application built as an intermediate-level Flutter developer interview assignment.

The application uses the Pixabay API to display images with pagination, search, favorites, image details, downloading, sharing, and local persistence.

## Features

* Responsive image gallery
* Infinite scrolling / pagination
* Pixabay API integration
* Search images
* Pull-to-refresh
* Image detail screen
* Image metadata
* Favorites
* Local favorite persistence using Hive
* Download images
* Download progress indicator
* Share image URL
* Cached image loading
* Loading, empty, and error states
* Retry handling
* Hero image animation
* Responsive layout for mobile, tablet, and larger screens
* Unit tests
* BLoC tests
* Widget test

## Tech Stack

* Flutter
* Dart
* BLoC
* Dio
* Hive
* Cached Network Image
* Flutter Dotenv
* Share Plus
* Path Provider
* Equatable
* bloc_test
* Mocktail

## Architecture

The application follows a feature-based architecture with separation between presentation, domain, and data layers.

```text
lib/
├── app/
│   ├── app.dart
│   └── routes.dart
│
├── core/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── share/
│   └── storage/
│
├── feature/
│   └── gallery/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

### Architecture Flow

```text
UI
 ↓
BLoC
 ↓
Repository
 ↓
Data Source / Local Storage
 ↓
Pixabay API / Hive
```

### Presentation Layer

Responsible for:

* Flutter screens
* Widgets
* User interactions
* BLoC state rendering

### Domain Layer

Contains:

* Entities
* Repository contracts

The domain layer does not depend directly on Dio, Hive, or Flutter UI.

### Data Layer

Responsible for:

* API communication
* JSON-to-model conversion
* Repository implementation
* Local favorite persistence

## State Management

BLoC is used for predictable state management.

### GalleryBloc

Handles:

* Initial image loading
* Pagination
* Search
* Pull-to-refresh
* Loading states
* Error states

### FavoritesBloc

Handles:

* Loading favorites
* Adding favorites
* Removing favorites
* Toggling favorites

### DownloadBloc

Handles:

* Image download
* Download progress
* Download success
* Download failure

## API

The application uses the Pixabay public image API.

API base URL:

```text
https://pixabay.com/api/
```

The API key is loaded from an environment variable.

## API Key Configuration

Create a `.env` file in the project root:

```env
PIXABAY_API_KEY=YOUR_PIXABAY_API_KEY
```

The `.env` file is intentionally excluded from Git.

An example configuration is provided in:

```text
.env.example
```

## Setup

### 1. Clone the repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
```

### 2. Open the project

```bash
cd infinite_image_gallery
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Configure API key

Create `.env`:

```env
PIXABAY_API_KEY=YOUR_PIXABAY_API_KEY
```

### 5. Run the application

```bash
flutter run
```

## Testing

Run all tests:

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

Format the project:

```bash
dart format lib test
```

## Testing Coverage

The project includes tests for:

* Image model JSON parsing
* Gallery BLoC
* Gallery loading
* Gallery pagination
* Gallery refresh
* Gallery error handling
* Favorites BLoC
* Add favorite
* Remove favorite
* Toggle favorite
* Download BLoC
* Basic widget rendering

## Pagination

The application uses Pixabay pagination parameters:

```text
page
per_page
```

The application initially loads page 1 and requests subsequent pages when the user approaches the bottom of the gallery.

The gallery avoids requesting another page while a pagination request is already in progress.

## Image Performance

`cached_network_image` is used to improve image loading performance and reduce unnecessary network requests.

Preview images are used in the gallery while larger images are loaded on the detail screen.

## Favorites Persistence

Favorites are stored locally using Hive.

The application stores the required image information so favorites remain available after restarting the application.

## Download

Images can be downloaded from the detail screen.

The application displays download progress and handles download failures.

Downloaded files are stored in the application's local documents directory.

## Sharing

The application uses the platform share functionality to share the image URL.

## Responsive UI

The gallery adapts the number of columns based on screen width.

```text
Mobile       → 2 columns
Tablet       → 3 columns
Small desktop → 4 columns
Large desktop → 5 columns
```

## Error Handling

The application handles:

* Missing API key
* Network errors
* Connection timeout
* Server errors
* API rate limiting
* Invalid API responses
* Image loading failures
* Download failures
* Empty results

## Assumptions

* Pixabay API is available and accessible.
* A valid Pixabay API key is required.
* Favorites are stored locally on the device.
* Downloaded images are initially stored in the application's private documents directory.
* Internet access is required to retrieve images from Pixabay.

## Limitations

* The current download implementation stores images in application-private storage rather than the device gallery.
* Pixabay API availability and rate limits may affect image loading.
* Favorite data is local to the device and is not synchronized between devices.

## Future Improvements

Possible future improvements include:

* Separate FavoritesRepository
* Saving downloaded images directly to the device gallery
* Download queue management
* Download cancellation
* More advanced search debounce
* Category filters
* Masonry layout
* Dark/light theme persistence
* More extensive widget testing
* Integration testing
* Offline image browsing
* Analytics and crash reporting

## Screenshots

Add screenshots here before submitting the assignment.

Example:

```text
screenshots/
├── gallery.png
├── search.png
├── detail.png
└── favorites.png
```

## APK

A release APK is provided separately with the assignment submission.

## Author

Ahamed Abisheik S

Flutter Developer

