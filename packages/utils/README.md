# Utils

## Description

The `utils` package provides a collection of reusable utilities, extensions, constants, error handling, logging, and infrastructure helpers for Flutter projects. It is designed to be shared across multiple apps and features, promoting code reuse and consistency in a monorepo or multi-package setup.

## Overview

**Key Features:**
- Common extensions for `BuildContext`, `String`, `Duration`, `double`, and more
- Centralized constants and breakpoints for responsive layouts
- Error handling and result types
- Logging infrastructure and sinks
- Routing helpers (e.g., GoRouter refresh stream)
- Test helpers for widget and unit testing

**Folder Structure:**

```
lib/
	utils.dart                # Barrel file for exports
	src/
		constants/              # Breakpoints, constants
		exceptions/             # Error handling, result types
		extensions/             # BuildContext, String, Duration, etc.
		infrastructure/         # Bloc observer, error handler
		logging/                # Logging sinks, custom logger
		routing/                # GoRouter refresh stream
test/
	helpers/                  # Test helpers, pumpApp, testWidget
	src/                      # Extension tests
```
