# Stopwatch

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

## Flutter Stopwatch App

A stopwatch application built with Flutter, following clean architecture principles. This project demonstrates state management using the BLoC library, testing, and modular design for scalable Flutter apps.

The project template was generated with [very_good_cli](https://pub.dev/packages/very_good_cli) (v0.27.0) and was developed on **Flutter 3.35.3**. 

## Features

- **Stopwatch Functionality**: Start, pause, stop, and record laps with millisecond precision.
- **Multiple Clock Displays**: Digital and analog clock widgets for flexible UI.
- **State Management**: Bloc pattern.
- **Clean Architecture**: Separation of data, domain, and presentation layers.
- **Testing**:
    - Unit, widget, and integration tests
    - Custom robots and fakes for UI and business logic coverage
- **Platform Support**: Android, iOS, Web, macOS, Windows

## ⚠️ Missing Features / Roadmap

- **Persistence (Planned)**: The architecture is prepared for future support of persistent stopwatch state, enabling the stopwatch to continue running in the background and survive app restarts.
  
    ⚠️ *This feature is not yet implemented. The codebase is structured for easy extension to background and persistent operation, but persistence is currently missing.*

The `packages/` directory contains shared Flutter package(s) for modularity and code reuse. Each package is intended to be reused across multiple apps inside an organization - either in a `monorepo` setup like in this project - or `published separately` for easy dependency handling. 

- **utils/**: Common utilities, constants, extensions, and error handling used across multiple apps and features.

## Project Structure

- **The project follows a feature-first clean architecture style**

```
lib/
    app/                # App bootstrap, theming, navigation
    exceptions/         # Error handling
    features/
        stopwatch/        # Stopwatch feature
            data/           # Data sources, models, repositories
            domain/         # Entities, repositories, services, use cases
            presentation/   # Bloc, widgets, pages
    routing/            # Routing configuration
    l10n/               # Localization files

integration_test/     # End-to-end and workflow tests
    app_robot.dart      # Robot for UI automation
    app_test.dart       # Main integration test
    workflows.dart      # Complex workflow coverage

test/                 # Unit and widget tests
    feature/            # Feature-specific tests
    helpers/            # Test helpers, fakes, robots


packages/
    utils/              # Common utilities, extensions, error handling. 
```

## Getting Started

1. **Clone the repository**
     ```sh
     git clone https://github.com/ZsoltFischer/Flutter-Stopwatch.git
     cd Flutter-Stopwatch
     ```
2. **Install dependencies**
     ```sh
     flutter pub get
     ```
3. **Run the app**
This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configurationd in VSCode or run the appropriate command:

    - Run
```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```
4. **Run tests**
     - Unit/Widget tests: 
```sh
$ flutter test
```
or
```sh
$ very_good test --coverage --test-randomize-ordering-seed random
```

     - Integration tests (requires emulator/device):
```sh
$ flutter test integration_test --flavor <flavor> integration_test/app_test.dart
```
To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

## Testing Approach

- **Unit Tests**: Validate business logic and state transitions.
- **Widget Tests**: Verify UI rendering and interaction in `test/feature/stopwatch/presentation/widgets/`.
- **Integration Tests**: Use `integration_test/app_robot.dart` for complex workflows and end-to-end scenarios.
- **Test Helpers**: Custom fakes, robots, and pump helpers for maintainable tests.

## Architecture

- **Feature-first**
-- **Data Layer**: Handles data sources, models, and repository implementations.
-- **Domain Layer**: Contains entities, repository interfaces, services, and use cases.
-- **Presentation Layer**: Manages UI, Bloc state, and widget composition.

## Localization

- ARB files in `lib/l10n/arb/` for supported languages
- Generated localization classes in `lib/l10n/gen/`

## Author

- [Zsolt Fischer](https://github.com/ZsoltFischer)

---

For more details, see the source code and tests in the repository.

---

## Working with Translations 

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:stopwatch/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

1. Generate localizations for the current project:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
