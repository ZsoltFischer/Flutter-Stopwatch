# Utils

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

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
