# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter mobile app ("pegadas_na_pista" — Portuguese, "tracks on the trail"). Very early scaffold stage: `lib/` currently only has the default `main.dart` counter demo, but the directory structure under `lib/core/` (`database`, `errors`, `location`, `network`, `permissions`, `utils`) and `lib/features/` is already laid out, signaling a layered/feature-first architecture is intended even though it's not populated yet.

## Toolchain

This project pins its Flutter SDK via **FVM** (`.fvmrc` → Flutter 3.44.4). Always use `fvm flutter` / `fvm dart`, not a bare global `flutter`/`dart`, so you match the pinned SDK version.

```bash
fvm flutter pub get              # install dependencies
fvm flutter run                  # run on connected device/simulator
fvm flutter test                 # run all tests
fvm flutter test test/widget_test.dart   # run a single test file
fvm flutter analyze              # static analysis / lints
fvm dart format .                # format code
fvm flutter build apk            # Android build
fvm flutter build ios            # iOS build
```

## Lint config

`analysis_options.yaml` extends `package:flutter_lints/flutter.yaml` with these project-specific overrides:
- `prefer_single_quotes: true` — use single quotes for strings.
- `require_trailing_commas: true` — trailing commas required (enables better dartfmt diffs).
- `avoid_print: false` — `print` is allowed.
- Formatter preserves existing trailing-comma style (`trailing_commas: preserve`).

## Dependencies / stack

- **State management**: `flutter_bloc` (+ `equatable` for value equality of states/events).
- **DI**: `get_it` (service locator).
- **Routing**: `go_router`.
- **Persistence**: `sqflite` (local SQLite) — matches the empty `lib/core/database/` folder.
- **Location**: `geolocator` — matches `lib/core/location/`.
- **Networking**: `dio` + `connectivity_plus` — matches `lib/core/network/`.
- **Permissions**: `permission_handler` — matches `lib/core/permissions/`.
- **Media**: `image_picker`.
- **Files**: `path`, `path_provider`.

When adding new code, follow the existing `lib/core/*` (cross-cutting infrastructure) vs `lib/features/*` (feature modules) split implied by the current folder layout, rather than introducing a different structure.

## Constructor convention

Every class has a **single, plain constructor** (no `.create`/`.of`-style name, no private `._` constructor paired with a factory). Bind fields with **named parameters via initializing formals** (`required this.field`), the way `trail_recording_cubit.dart` and `trail_recording_state.dart` do:

```dart
class TrailRecordingCubit extends Cubit<TrailRecordingState> {
  TrailRecordingCubit({required this.startTrail, required this.locationService})
      : super(const TrailRecordingIdle());

  final StartTrail startTrail;
  final LocationService locationService;
}

final class TrailRecordingInProgress extends TrailRecordingState {
  const TrailRecordingInProgress({required this.trail});

  final Trail trail;
}
```

Fields backing a named constructor parameter are **public** (no leading underscore). Dart can never resolve a named argument against a private identifier — not from another file, not even from the same file — so `required this._field` is a broken constructor, not just a style nit; it cannot be called with a named argument anywhere. Keep fields private only when they're *not* constructor parameters (derived/internal state).

Exceptions:
- **Flutter widgets** (`StatelessWidget`/`StatefulWidget`) keep `super.key` — framework convention.
- **Zero-field static-utility classes** (e.g. `AppRouter`) need no explicit constructor at all.
- **Zero-field marker classes** (e.g. `TrailRecordingIdle`) just declare `const ClassName();`.
