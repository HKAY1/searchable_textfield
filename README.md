<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Searchable TextField

A customizable Flutter widget that combines the functionality of a TextField with dropdown search capabilities.

## Features

- Standard TextField functionality
- Dropdown with search functionality
- API-based search support
- Pagination for large datasets
- Customizable appearance
- Form validation support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  searchable_textfield: ^latest_version
```

## Usage

Basic example:

```dart
SearchableTextField(
  controller: TextEditingController(),
  enabled: true,
  isDropdown: true,
  isObscured: false,
  items: [
    DropdownMenuItems(lable: "Item 1", value: "1"),
    DropdownMenuItems(lable: "Item 2", value: "2"),
  ],
  onChanged: (value) {
    print("Selected value: $value");
  },
)
```

API-based search example:

```dart
SearchableTextField(
  controller: TextEditingController(),
  enabled: true,
  isDropdown: true,
  isObscured: false,
  getItems: ({page, filter, limit}) async {
    // Implement your API call here
    return yourApiCall(page: page, searchText: filter, pageSize: limit);
  },
  onChanged: (value) {
    print("Selected value: $value");
  },
)
```

## API Reference

### Main Properties

- `controller`: TextEditingController for managing the text input
- `enabled`: Enables/disables the text field
- `isDropdown`: Enables dropdown functionality
- `items`: List of predefined dropdown items
- `getItems`: Function for API-based item fetching
- `onChanged`: Callback for value changes
- `validator`: Form validation function
- `isObscured`: Toggle password visibility
- `textFeildDecorator`: Custom input decoration

### DropdownMenuItems

```dart
DropdownMenuItems({
  required String lable,
  required String value,
})
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
