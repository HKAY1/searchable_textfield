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
- **Appendable items**: Add a separate list of widgets below the dropdown with dynamic height adjustment

## Upcoming Updates

- Multi-select support
- Loading indicator for API-based searches
- Empty state handling with customizable empty state widget
- Additional TextField parameters support
- Custom UI option for dropdown items
- Improved decoration customization options
- Performance optimizations for large datasets

## Support My Work

If you find this package useful, consider supporting me with a coffee. Your support helps me maintain and improve this package! ☕️

<div style="align:center">
  <a href="https://buymeacoffee.com/harsh001" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;">
  </a>
</div>

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

### Appendable Items Example

You can add a separate list of widgets below the dropdown using the `appendableItems` property. These widgets will be displayed in a separate section with dynamic height adjustment.

```dart
SearchableTextField(
  controller: TextEditingController(),
  enabled: true,
  isDropdown: true,
  isObscured: false,
  items: [
    DropdownMenuItems(lable: "Apple", value: "1"),
    DropdownMenuItems(lable: "Mango", value: "2"),
  ],
  appendableItems: [
    ListTile(
      leading: Icon(Icons.add),
      title: Text("Add New Item"),
      onTap: () {
        print("Add New Item tapped");
      },
    ),
    Divider(),
    ListTile(
      leading: Icon(Icons.info),
      title: Text("About"),
      onTap: () {
        print("About tapped");
      },
    ),
  ],
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
- `dropdownDecoration`: Custom BoxDecoration for dropdown container
- `dropdownItemStyle`: TextStyle for dropdown items
- `dropdownBackgroundColor`: Background color of dropdown
- `dropdownItemPadding`: Padding for dropdown items
- `dropdownElevation`: Elevation of dropdown container
- `loadingWidget`: Custom widget to show while loading items
- `loadingIndicatorColor`: Color of the default loading indicator
- `loadingIndicatorSize`: Size of the default loading indicator (default: 20)
- `loadingIndicatorStrokeWidth`: Stroke width of the default loading indicator (default: 2)
- `appendableItems`: A list of widgets to display in a separate section below the dropdown

## Usage with Custom Styling

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
  dropdownDecoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey),
  ),
  dropdownItemStyle: TextStyle(
    color: Colors.blue,
    fontSize: 16,
  ),
  dropdownBackgroundColor: Colors.grey[100],
  dropdownItemPadding: EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 15,
  ),
  dropdownElevation: 4,
  onChanged: (value) {
    print("Selected value: $value");
  },
)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Connect with me

- GitHub: [Your GitHub Profile](https://github.com/HKAY1)
- LinkedIn: [Your LinkedIn Profile](https://www.linkedin.com/in/harsh-kumar-b8034020a?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
