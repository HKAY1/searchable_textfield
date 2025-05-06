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

A highly customizable Flutter widget that combines TextField functionality with dropdown search capabilities, multi-select support, and API integration.

## Features

- Standard TextField functionality with full customization
- Dropdown with search functionality
- API-based search support with pagination
- Multi-select support with checkbox customization
- Appendable items support
- Form validation support
- Customizable loading indicators
- Rich text input customization
- Keyboard handling and input formatting

## Support My Work

If you find this package useful, consider supporting me with a coffee. Your support helps me maintain and improve this package! ☕️

<div style="align:center">
  <a href="https://buymeacoffee.com/harsh001" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;">
  </a>
</div>

## Installation

```yaml
dependencies:
  searchable_textfield: ^latest_version
```

## Basic Usage

```dart
SearchableTextField(
  controller: TextEditingController(),
  enabled: true,
  isDropdown: true,
  items: [
    DropdownMenuItems(lable: "Item 1", value: "1"),
    DropdownMenuItems(lable: "Item 2", value: "2"),
  ],
  onChanged: (value, label) {
    print("Selected value: $value, label: $label");
  },
)
```

## Multi-Select Example

```dart
SearchableTextField(
  controller: TextEditingController(),
  isDropdown: true,
  isMultiSelect: true,
  checkboxActiveColor: Colors.blue,
  checkboxCheckColor: Colors.white,
  selectedItemStyle: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  ),
  maxSelections: 3,
  selectionSeparator: ' | ',
  items: [
    DropdownMenuItems(lable: "Item 1", value: "1"),
    DropdownMenuItems(lable: "Item 2", value: "2"),
  ],
)
```

## API Integration

```dart
SearchableTextField(
  controller: TextEditingController(),
  isDropdown: true,
  getItems: ({page, filter, limit}) async {
    // Your API call here
    return yourApiResponse.map((item) => 
      DropdownMenuItems(lable: item.name, value: item.id)
    ).toList();
  },
  loadingWidget: YourCustomLoadingWidget(),
)
```

## Customization Options

### Core Properties
- `controller`: TextEditingController for managing input
- `enabled`: Enable/disable the field
- `isDropdown`: Enable dropdown functionality
- `isMultiSelect`: Enable multi-select mode
- `validator`: Form validation function
- `onChanged`: Callback for value changes (value, label)

### Visual Customization
- `style`: Text style for input
- `dropdownItemStyle`: Style for dropdown items
- `selectedItemStyle`: Style for selected items
- `dropdownDecoration`: Custom dropdown BoxDecoration
- `dropdownBackgroundColor`: Background color
- `dropdownItemPadding`: Padding for items
- `dropdownElevation`: Shadow elevation

### Multi-select Options
- `maxSelections`: Limit number of selections
- `selectionSeparator`: Separator for selected items
- `checkboxActiveColor`: Color when checked
- `checkboxCheckColor`: Checkbox tick color
- `selectionIndicator`: Custom indicator widget

### Input Handling
- `keyboardType`: Type of keyboard to display
- `inputFormatter`: Input formatting rules
- `textAlign`: Text alignment
- `textAlignVertical`: Vertical alignment
- `readOnly`: Prevent editing
- `obscureText`: Hide input text
- `maxLines`/`minLines`: Line constraints
- `maxLength`: Character limit

### Advanced Features
- `autofillHints`: Autofill suggestions
- `scrollController`: Custom scroll control
- `scrollPhysics`: Scroll behavior
- `enableIMEPersonalizedLearning`: IME learning
- `cursorColor`/`cursorWidth`/`cursorRadius`: Cursor customization
- `smartDashesType`/`smartQuotesType`: Smart text formatting

## Contribution

Contributions are welcome! Please feel free to submit pull requests.

## Connect with me

- GitHub: [Your GitHub Profile](https://github.com/HKAY1)
- LinkedIn: [Your LinkedIn Profile](https://www.linkedin.com/in/harsh-kumar-b8034020a?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
