# InstagramPlus

An Instagram-inspired iOS app built with SwiftUI, Firebase Authentication, Cloud Firestore and Cloudinary. The project explores social app flows, asynchronous data loading, state management and testable service boundaries.

## Project background

InstagramPlus started from **Instagram SwiftUI Pro 2.0**, a course by **Stephan Dowless (AppStuff)**, and is being extended and adapted as a learning and portfolio project. The course provides the foundation; the adaptations listed below describe my changes to that foundation.

My adaptations include:

- **Cloudinary image storage and uploads** in place of Firebase Storage, including profile and post images.
- **Cloudflare backend integration**, currently in progress, as an alternative to Firebase Cloud Functions. This integration is not yet represented in the current app source.

This is a work-in-progress project, not a production release. It is not affiliated with Instagram or Meta.

## Features in the current codebase

- Email/password sign-in and multi-step registration.
- Registration input validation and authentication state management.
- User profiles, profile editing and profile image uploads.
- Photo posts with captions, uploaded through Cloudinary.
- A feed with incremental loading and pull-to-refresh controls.
- Likes, saved posts and comments.
- User discovery, following and follower/following lists.
- In-app activity notifications for social interactions.
- Loading, empty and error states in selected flows.

## Technology

| Area | Implementation |
| --- | --- |
| UI | SwiftUI, Observation (`@Observable`), `NavigationStack` |
| Asynchronous work | Swift concurrency, `async`/`await`, throwing task groups |
| Authentication | Firebase Authentication |
| App data | Cloud Firestore |
| Image uploads | Cloudinary iOS SDK |
| Remote image loading | Kingfisher |
| Tests | XCTest with mock services |
| Dependencies | Swift Package Manager |

The Xcode project still includes the Firebase Storage package product, although the current image uploader uses Cloudinary.

## Architecture

The app uses an MVVM-style structure organised around features. Views handle presentation, view models manage feature state and interactions, and services perform data operations.

Several services expose protocols, including `AuthServiceProtocol`, `UserServiceProtocol`, `FeedServiceProtocol` and `CommentServiceProtocol`. These boundaries allow selected view models and managers to use mock implementations in tests.

`AuthManager` and `UserManager` are created at the app entry point and supplied through the SwiftUI environment. Authentication and feed navigation have dedicated routing types.

The separation is incremental: some areas still access Firebase directly or use shared managers and static services. The project does not claim complete dependency isolation.

### Suggested code walkthrough

- [`AuthManager`](InstagramPlus/Core/Authentication/Manager/AuthManager.swift): authentication state and injected service dependency.
- [`AuthenticationRouter`](InstagramPlus/Core/Authentication/AuthenticationRouter.swift): multi-step registration navigation.
- [`FeedViewModel`](InstagramPlus/Core/Feed/ViewModel/FeedViewModel.swift): feed state, concurrent user-data loading and optimistic interaction updates.
- [`CommentViewModel`](InstagramPlus/Core/Comments/ViewModel/CommentViewModel.swift): comment loading and submission with injected services.
- [`ImageUploader`](InstagramPlus/Services/ImageUploader.swift): Cloudinary uploads bridged to `async`/`await` using a throwing continuation.

## Getting started

### Requirements

- macOS and an Xcode installation with an SDK and simulator compatible with the project's deployment target.
- The current project sets its **iOS deployment target to 26.5** and its **Swift language mode to 5**. Check these settings against your installed toolchain before building.
- Your own Firebase project and Cloudinary account.

### Configuration

1. Clone the repository and open `InstagramPlus.xcodeproj` in Xcode.
2. Allow Xcode to resolve Swift Package Manager dependencies.
3. Register an iOS app in your Firebase project using the bundle identifier configured in Xcode.
4. Enable Email/Password authentication and create a Cloud Firestore database.
5. Replace `InstagramPlus/GoogleService-Info.plist` with the configuration downloaded for your own Firebase app. Ensure it is included in the app target.
6. Configure Firestore access rules for your own project. Rules, index definitions and a backend provisioning script are not currently included in this repository; backend setup is therefore manual.
7. Copy `InstagramPlus/Secrets.example.plist` to `InstagramPlus/Secrets.plist`, then set:
   - `CLOUDINARY_CLOUD_NAME`
   - `CLOUDINARY_UPLOAD_PRESET`
8. Configure a Cloudinary upload preset that supports the app's client-side unsigned uploads. Ensure `Secrets.plist` is included in the app bundle. The file is excluded from Git.
9. Select the `InstagramPlus` app scheme and a compatible simulator, then build and run. For a physical device, configure your signing team and bundle identifier.

Do not include a Cloudinary API secret in the app. Values shipped in an iOS bundle are accessible to users; restrict the upload preset appropriately in Cloudinary.

## Tests

The `InstagramPlusTests` target contains XCTest suites for:

- Authentication manager success and failure paths.
- Login view-model state and error handling.
- Registration state, validation and account creation.
- Registration routing and reset behaviour.
- Comment loading, empty/error states and submission.

The tests use mock authentication, user and comment services. Test files live alongside their corresponding features under `Core/Authentication/Tests` and `Core/Comments/Tests`.

To run them, select a compatible simulator in Xcode and use **Product → Test** (`⌘U`). Ensure the `InstagramPlusTests` target is enabled in the scheme's Test action. The app's startup still configures Firebase, so mock-based tests do not imply a fully configuration-free app launch.

There is no dedicated UI test suite or backend integration test suite in the current repository. Tests against mocks verify client-side behaviour; they do not establish that the real Firebase operations are implemented or working.

## Current limitations and ongoing work

- Cloudflare integration is in progress and is not yet included in the app source reviewed here.
- Account deletion and password-reset service methods are currently placeholders in the real `AuthService` implementation.
- Backend provisioning, Firestore rules and index configuration are not bundled with the app.
- Automated tests currently cover selected authentication and comment flows, rather than the whole application.
- Feed pagination and refresh behaviour are areas for further validation and test coverage.

## Repository structure

```text
InstagramPlus/
├── App/                 # App entry point and environment setup
├── Core/                # Authentication, feed, profiles, comments and other features
├── Components/          # Reusable UI and supporting view models
├── Shared/              # User services, managers, shared models and mock data
├── Services/            # Post services, image upload and Cloudinary configuration
├── Extensions/          # Validation helpers, date utilities and preview support
└── Utils/               # Firestore collection references and shared constants
```

## Author

[Zsolt Gábor](https://github.com/ZsoltGaborDev)
