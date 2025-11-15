# Shared Packages

This directory contains shared Dart/Flutter packages that can be used across multiple applications in the monorepo.

## Purpose

The `packages/` directory is designed to house reusable libraries and utilities that are shared between different apps or can be published independently to pub.dev.

## Future Packages

As the project grows, consider extracting shared functionality into packages here:

### Potential Packages

- **`flight_data_core`** - Core flight data models and API client for OpenSky Network
  - Reusable across multiple flight-related apps
  - Can be tested independently
  - Easy to version and publish

- **`ar_engine`** - AR rendering engine abstractions
  - Platform-agnostic AR utilities
  - Sensor fusion algorithms
  - AR stabilization logic

- **`location_core`** - Location services wrapper
  - GPS and location utilities
  - Permission handling
  - Distance calculations

- **`skwark_design_system`** - Shared UI components and theme
  - Material 3 components
  - Custom widgets
  - Shared animations

## Creating a New Package

To create a new package in this directory:

```bash
cd packages
flutter create --template=package your_package_name
```

Then add it to your app's `pubspec.yaml`:

```yaml
dependencies:
  your_package_name:
    path: ../../packages/your_package_name
```

After adding a new package, run:

```bash
melos bootstrap
```

## Benefits of Shared Packages

1. **Code Reusability** - Write once, use across multiple apps
2. **Independent Testing** - Test packages in isolation
3. **Version Control** - Manage versions independently
4. **Clear Boundaries** - Enforce separation of concerns
5. **Faster CI/CD** - Only rebuild affected packages
6. **Easy Publishing** - Publish packages to pub.dev when ready

## Current Status

Currently, all code is in the main app (`apps/skwark`). As the project grows and you identify reusable components, migrate them to packages here.
