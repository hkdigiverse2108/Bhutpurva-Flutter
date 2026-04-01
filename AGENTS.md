# AGENTS.md — gurukul_bhutpurva

This file provides Codex with essential context about the project architecture,
conventions, and strict rules to follow when reading or modifying this codebase.

---

## Project Overview

**gurukul_bhutpurva** is a Flutter mobile application built for alumni management.
It follows a **Feature-based Modular Architecture** with a strict separation between
core services, data models, and feature modules.

- **State Management:** GetX (`GetxController`, `Obx`, `Rx` variables)
- **Navigation:** GetX named routes (`Get.toNamed`, `Get.back`)
- **Dependency Injection:** GetX (`Get.put`, `Get.find`, `GetView<T>`)
- **Flutter version:** 3.41+

---

## Folder Structure (`lib/`)

```
lib/
├── app/
│   ├── app_pages.dart         # Centralized GetPage definitions
│   ├── app_routes.dart        # Route name constants
│   └── app_binding.dart       # Global DI for services
├── core/
│   ├── services/              # Singleton services (ApiService, StorageService, AuthService)
│   ├── constants/             # Colors, enums, themes, API endpoints
│   └── mixins/                # Shared controller logic (e.g. LocationDropdownMixin)
├── data/
│   └── models/                # JSON serialization models (User, Member, Survey, etc.)
├── modules/                   # Feature modules
│   └── [feature]/
│       ├── bindings/          # Feature-specific DI
│       ├── controllers/       # GetxController subclasses
│       └── views/             # GetView<T> subclasses
└── shared/
    └── widgets/               # Reusable UI components (buttons, snackbars, form fields)
```

---

## Core Packages

| Package | Usage |
|---|---|
| `get` | State management, navigation, DI |
| `gap` | **Exclusive** spacing widget — use `Gap(n)` instead of `SizedBox` |
| `phosphor_flutter` | **Primary** icon library — prefer over Material icons |
| `get_storage` | User session and profile persistence |
| `intl` | Date/time formatting and localization |
| `connectivity_plus` | Offline state handling via `ApiService` |
| `share_plus` / `url_launcher` | External interactions |

---

## Strict Rules — NEVER Violate These

### 🚫 No StatefulWidget or setState
All UI must be fully reactive. Use `Obx` with `Rx` variables in `GetxController`.

```dart
// ❌ WRONG
class MyWidget extends StatefulWidget { ... }

// ✅ CORRECT
class MyWidget extends GetView<MyController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.name.value));
  }
}
```

### 🚫 No Direct Service Instantiation
Never instantiate services manually. Always use the registered singleton.

```dart
// ❌ WRONG
final apiService = ApiService();

// ✅ CORRECT
final apiService = ApiService.to;
final storage = Get.find<StorageService>();
```

### 🚫 No Forced Null-Checks (!)
Use null-safe operators, especially on form keys and API data.

```dart
// ❌ WRONG
formKey.currentState!.validate();

// ✅ CORRECT
formKey.currentState?.validate() ?? true;
```

### 🚫 No Local Controller Instantiation
Never create controllers manually. Use GetX DI.

```dart
// ❌ WRONG
final controller = MyController();

// ✅ CORRECT — via GetView
class MyView extends GetView<MyController> { ... }

// ✅ CORRECT — via Get.find
final controller = Get.find<MyController>();
```

---

## Controller Conventions

- Extend `GetxController`
- Use `ApiService.to` for all API calls
- Use `RxList`, `RxBool`, `Rx<Model?>` for reactive state
- Loading states must use `RxBool` (e.g. `isLoading`, `isMonitorLoading`)
- Always `dispose` `TextEditingController`s in `onClose()`

```dart
class MyController extends GetxController {
  final apiService = ApiService.to;
  final storage = Get.find<StorageService>();

  final isLoading = false.obs;
  final items = <MyModel>[].obs;

  @override
  void onClose() {
    myTextController.dispose();
    super.onClose();
  }
}
```

---

## Model Conventions

- All models must have `fromJson` and `toJson` methods
- Use `.toString()` for ID fields to handle both `String` and `ObjectId` from API
- Never use forced `!` on nullable JSON fields — use `?? ''` or `?? []` defaults

```dart
factory MyModel.fromJson(Map<String, dynamic> json) => MyModel(
  id: json['_id']?.toString() ?? '',
  name: json['name'] ?? '',
);
```

---

## Spacing & Icons

```dart
// ✅ Use Gap for spacing
Gap(12)       // instead of SizedBox(height: 12)
Gap(8)        // instead of SizedBox(width: 8)

// ✅ Use Phosphor icons
PhosphorIconsBold.trash
PhosphorIconsBold.pencilSimpleLine
// Avoid generic Material Icons unless no Phosphor equivalent exists
```

---

## API Constants

All endpoints are defined in `lib/core/constants/api_constants.dart`.
Never hardcode URLs or endpoint strings in controllers or views.

```dart
// ✅ CORRECT
ApiConstants.batchDetails(id)
ApiConstants.monitors(batchFilter: id)
```

---

## Notes for Codex

- Always check `lib/core/constants/api_constants.dart` before adding new endpoints
- Always check `lib/shared/widgets/` before creating new UI components
- When adding a new feature, follow the `modules/[feature]/bindings|controllers|views` structure
- Preserve existing `AnimatedSwitcher` and transition patterns when modifying tab/page switching UI
