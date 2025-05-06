// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchable_textfeild/dropdown_menu_items.dart';

/// [SearchableTextField] is a custom textfield widget that can function as a standard textfield
/// or a dropdown with search functionality.
///
/// - If used as a dropdown with search, [getItems] should be defined for API-based search.
/// - [items] should be provided if using predefined dropdown values.
/// - Supports pagination for handling large datasets.
/// TODO: Add loading indicator.
/// TODO: Add empty state.
/// TODO: Add all textfeild parameters.
/// TODO: Add on menu item selected callback.

class SearchableTextField<T> extends StatefulWidget {
  // API Integration
  /// Function to fetch items from API with pagination and search support
  final Future<List<T>> Function({int? page, String? filter, int? limit})?
  getItems;

  // Core Properties
  /// Controller for managing text input
  final TextEditingController controller;

  /// Form validation function
  final String? Function(String?)? validator;

  /// Predefined list of dropdown items
  final List<DropdownMenuItems>? items;

  /// Callback when value changes, provides both value and label
  final Function(String? value, String? label)? onChanged;

  // Basic TextField Properties
  /// Enable/disable the text field
  final bool enabled;

  /// Enable dropdown functionality
  final bool isDropdown;

  /// Text style for input
  final TextStyle? style;

  /// Hide text (for password fields)
  final bool isObscured;

  /// Focus node for controlling focus
  final FocusNode? focusNode;

  /// Decoration for the text field
  final InputDecoration? textFeildDecorator;

  // Text Configuration
  /// Maximum number of lines
  final int maxLines;

  /// Minimum number of lines
  final int minLines;

  /// Maximum number of characters
  final int? maxLength;

  /// Keyboard type (numeric, email, etc)
  final TextInputType keyboardType;

  /// Input formatting rules
  final List<TextInputFormatter>? inputFormatter;

  /// Character for obscured text
  final String obscuringText;

  // Visual Customization
  /// Color of the cursor
  final Color? cursorColor;

  /// Custom decoration for dropdown
  final BoxDecoration? dropdownDecoration;

  /// Text style for dropdown items
  final TextStyle? dropdownItemStyle;

  /// Background color of dropdown
  final Color? dropdownBackgroundColor;

  /// Padding for dropdown items
  final EdgeInsetsGeometry dropdownItemPadding;

  /// Elevation of dropdown container
  final double? dropdownElevation;

  // Loading Indicator
  /// Custom loading widget
  final Widget? loadingWidget;

  /// Color of default loading indicator
  final Color? loadingIndicatorColor;

  /// Size of loading indicator
  final double loadingIndicatorSize;

  /// Stroke width of loading indicator
  final double loadingIndicatorStrokeWidth;

  // Multi-select Configuration
  /// Enable multi-select functionality
  final bool isMultiSelect;

  /// Color of selected checkbox
  final Color? checkboxActiveColor;

  /// Color of checkbox tick
  final Color? checkboxCheckColor;

  /// Style for selected items
  final TextStyle? selectedItemStyle;

  /// Maximum number of selections allowed
  final int? maxSelections;

  /// Separator for selected items in text field
  final String selectionSeparator;

  /// Custom indicator for selected items
  final Widget? selectionIndicator;

  // Additional Features
  /// List of widgets to show below dropdown
  final List<Widget>? appendableItems;

  // Text Alignment and Behavior
  /// Text alignment within field
  final TextAlign textAlign;

  /// Vertical alignment of text
  final TextAlignVertical? textAlignVertical;

  /// Focus when widget is mounted
  final bool autofocus;

  /// Prevent editing
  final bool readOnly;

  /// Show cursor
  final bool? showCursor;

  /// Expand to fill height
  final bool expands;

  // Input Actions and Callbacks
  /// Keyboard action button type
  final TextInputAction? textInputAction;

  /// Called when editing is complete
  final VoidCallback? onEditingComplete;

  /// Called when field is submitted
  final Function(String)? onSubmitted;

  /// Called when tapped outside
  final Function()? onTapOutside;

  // Advanced Features
  /// Hints for autofill service
  final List<String>? autofillHints;

  /// Enable IME personalized learning
  final bool enableIMEPersonalizedLearning;

  /// Controller for scrolling
  final ScrollController? scrollController;

  /// Scroll physics
  final ScrollPhysics? scrollPhysics;

  /// Padding when scrolling
  final EdgeInsets scrollPadding;

  /// Enable text selection
  final bool enableInteractiveSelection;

  /// Custom selection controls
  final TextSelectionControls? selectionControls;

  /// Custom counter builder
  final InputCounterWidgetBuilder? buildCounter;

  // Selection Styling
  /// Height style for selection
  final BoxHeightStyle selectionHeightStyle;

  /// Width style for selection
  final BoxWidthStyle selectionWidthStyle;

  /// Drag behavior
  final DragStartBehavior dragStartBehavior;

  /// Content insertion configuration
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// Clip behavior
  final Clip clipBehavior;

  /// Enable text suggestions
  final bool enableSuggestions;

  /// Enable autocorrect
  final bool autocorrect;

  /// Smart dashes type
  final SmartDashesType? smartDashesType;

  /// Smart quotes type
  final SmartQuotesType? smartQuotesType;

  // Cursor Customization
  /// Width of cursor
  final double cursorWidth;

  /// Height of cursor
  final double? cursorHeight;

  /// Radius of cursor
  final Radius? cursorRadius;

  /// Mouse cursor type
  final MouseCursor? mouseCursor;

  const SearchableTextField({
    super.key,
    this.items = const [],
    this.getItems,
    required this.controller,
    this.onChanged,
    this.validator,
    required this.enabled,
    this.style,
    this.isDropdown = false,
    this.isObscured = false,
    this.focusNode,
    this.textFeildDecorator,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.inputFormatter,
    this.obscuringText = '•',
    this.cursorColor,
    this.dropdownDecoration,
    this.dropdownItemStyle,
    this.dropdownBackgroundColor = Colors.white,
    this.dropdownItemPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.dropdownElevation = 8,
    this.loadingWidget,
    this.loadingIndicatorColor,
    this.loadingIndicatorSize = 20,
    this.loadingIndicatorStrokeWidth = 2,
    this.appendableItems = const [],
    this.isMultiSelect = false,
    this.checkboxActiveColor,
    this.checkboxCheckColor,
    this.selectedItemStyle,
    this.maxSelections,
    this.selectionSeparator = ', ',
    this.selectionIndicator,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.expands = false,
    this.textInputAction,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTapOutside,
    this.autofillHints,
    this.enableIMEPersonalizedLearning = true,
    this.scrollController,
    this.scrollPhysics,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.buildCounter,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.mouseCursor,
  }) : assert(
         !(isDropdown && (items == null || items == const [])),
         'Items cannot be empty when isDropdown is true.',
       );

  @override
  State<SearchableTextField> createState() => _SearchableTextFieldState();
}

class _SearchableTextFieldState extends State<SearchableTextField> {
  bool _isExpanded = false;
  List<DropdownMenuItems> _filteredItems = [];
  Timer? _debouncer;
  late ScrollController _scrollController;

  final int _initialLoadSize = 15;
  final int _loadSize = 5;
  int _page = 0;
  String filter = "";

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  bool _isNextLoading = false;
  bool _isPrevLoading = false;
  final Set<DropdownMenuItems> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);

    if (widget.isDropdown) {
      if (widget.items == null && widget.getItems == null) {
        throw Exception(
          'Either items list or getItems function must be provided.',
        );
      }
      if (widget.items!.isNotEmpty) {
        _filteredItems = List.from(widget.items!);
        _page = 2;
      }
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _scrollController.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadNextPage();
    } else if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      _loadPreviousPage();
    }
  }

  Future<void> _loadNextPage() async {
    if (widget.getItems == null || _isNextLoading) return;

    setState(() => _isNextLoading = true);
    try {
      debugPrint("Loading next page: $_page");
      final nextItems = await widget.getItems!(
        page: _page + 1,
        filter: filter,
        limit: _loadSize,
      );

      if (nextItems.isNotEmpty) {
        setState(() {
          _filteredItems.addAll(nextItems.cast<DropdownMenuItems>());
          _page++;
        });
      }
    } finally {
      setState(() => _isNextLoading = false);
    }
  }

  Future<void> _loadPreviousPage() async {
    if (widget.getItems == null || _page <= 0 || _isPrevLoading) return;

    setState(() => _isPrevLoading = true);
    try {
      debugPrint("Loading prev page: $_page");
      final items = await widget.getItems!(
        page: _page - 1,
        filter: filter,
        limit: _loadSize,
      );

      if (items.isNotEmpty) {
        setState(() {
          _filteredItems.insertAll(0, items.cast<DropdownMenuItems>());
          _page--;
        });
      }
    } finally {
      setState(() => _isPrevLoading = false);
    }
  }

  void runDebounced(VoidCallback action) {
    _debouncer?.cancel();
    _debouncer = Timer(const Duration(milliseconds: 200), action);
  }

  void _searchData() {
    runDebounced(() async {
      if (!widget.isDropdown) return;

      if (filter.isEmpty && widget.getItems == null) {
        _filteredItems = List.from(widget.items ?? []);
        setState(() {
          _isExpanded = true;
          if (_overlayEntry != null) {
            _removeOverlay();
            _showOverlay();
          }
        });
        return;
      }

      final data =
          widget.getItems == null
              ? widget.items!
                  .where(
                    (x) => x.lable.toLowerCase().contains(filter.toLowerCase()),
                  )
                  .toList()
              : (await widget.getItems!(
                page: 0,
                filter: filter,
                limit: _initialLoadSize,
              )).cast<DropdownMenuItems>();

      setState(() {
        _filteredItems = data;
        _isExpanded = true;
        _page = 2;
        if (_overlayEntry != null) {
          _removeOverlay();
          _showOverlay();
        }
      });
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildLoadingIndicator() {
    return widget.loadingWidget ??
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: widget.loadingIndicatorSize,
              width: widget.loadingIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: widget.loadingIndicatorStrokeWidth,
                color: widget.loadingIndicatorColor,
              ),
            ),
          ),
        );
  }

  void _updateTextController() {
    if (widget.isMultiSelect) {
      widget.controller.text = _selectedItems
          .map((item) => item.lable)
          .join(widget.selectionSeparator);
      for (var item in _selectedItems) {
        widget.onChanged?.call(item.value, item.lable);
      }
    }
  }

  bool _canAddMoreSelections() {
    return widget.maxSelections == null ||
        _selectedItems.length < widget.maxSelections!;
  }

  void _showOverlay() {
    _removeOverlay();
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // Calculate dropdown height
    final dropdownItemHeight = 48.0; // height per dropdown item
    final dropdownContentHeight = _filteredItems.length * dropdownItemHeight;
    final dropdownMaxHeight = MediaQuery.sizeOf(context).height * 0.3;
    final dropdownActualHeight =
        dropdownContentHeight < dropdownMaxHeight
            ? dropdownContentHeight
            : dropdownMaxHeight;

    // Calculate appendable items height
    final appendableItemHeight = 48.0; // height per appendable item
    final appendableContentHeight =
        (widget.appendableItems?.length ?? 0) * appendableItemHeight;
    final appendableMaxHeight = MediaQuery.sizeOf(context).height * 0.2;
    final appendableActualHeight =
        appendableContentHeight < appendableMaxHeight
            ? appendableContentHeight
            : appendableMaxHeight;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    _removeOverlay();
                    setState(() => _isExpanded = false);
                  },
                  child: Container(color: Colors.transparent),
                ),
              ),
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown section
                    Material(
                      elevation: widget.dropdownElevation ?? 8,
                      borderRadius: BorderRadius.circular(4),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: size.width,
                        height: dropdownActualHeight,
                        decoration:
                            widget.dropdownDecoration ??
                            BoxDecoration(
                              color: widget.dropdownBackgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(
                            context,
                          ).copyWith(scrollbars: false),
                          child: CupertinoScrollbar(
                            controller: _scrollController,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: _scrollController,
                              itemCount:
                                  _filteredItems.length +
                                  (_isNextLoading ? 1 : 0) +
                                  (_isPrevLoading ? 1 : 0),
                              itemExtent: dropdownItemHeight,
                              itemBuilder: (context, index) {
                                if (_isPrevLoading && index == 0) {
                                  return _buildLoadingIndicator();
                                }
                                if (_isNextLoading &&
                                    index == _filteredItems.length) {
                                  return _buildLoadingIndicator();
                                }

                                final item = _filteredItems[index];
                                if (widget.isMultiSelect) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (_selectedItems.contains(item)) {
                                          _selectedItems.remove(item);
                                        } else if (_canAddMoreSelections()) {
                                          _selectedItems.add(item);
                                        }
                                        _updateTextController();
                                        _removeOverlay();
                                        _showOverlay();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Checkbox(
                                              value: _selectedItems.contains(
                                                item,
                                              ),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              activeColor:
                                                  widget.checkboxActiveColor,
                                              checkColor:
                                                  widget.checkboxCheckColor,
                                              onChanged:
                                                  _canAddMoreSelections() ||
                                                          _selectedItems
                                                              .contains(item)
                                                      ? (bool? value) {
                                                        setState(() {
                                                          if (value == true) {
                                                            _selectedItems.add(
                                                              item,
                                                            );
                                                          } else {
                                                            _selectedItems
                                                                .remove(item);
                                                          }
                                                          _updateTextController();
                                                          _removeOverlay();
                                                          _showOverlay();
                                                        });
                                                      }
                                                      : null,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              item.lable,
                                              style:
                                                  _selectedItems.contains(item)
                                                      ? widget.selectedItemStyle
                                                      : widget
                                                          .dropdownItemStyle,
                                            ),
                                          ),
                                          if (_selectedItems.contains(item) &&
                                              widget.selectionIndicator != null)
                                            widget.selectionIndicator!,
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      widget.controller.text = item.value;
                                      widget.onChanged?.call(
                                        item.value,
                                        item.lable,
                                      );
                                      setState(() => _isExpanded = false);
                                      _removeOverlay();
                                    },
                                    child: Padding(
                                      padding: widget.dropdownItemPadding,
                                      child: Text(
                                        item.lable,
                                        style: widget.dropdownItemStyle,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Appendable items section
                    if (widget.appendableItems != null &&
                        widget.appendableItems!.isNotEmpty)
                      Material(
                        elevation: widget.dropdownElevation ?? 4,
                        borderRadius: BorderRadius.circular(4),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          width: size.width,
                          height: appendableActualHeight,
                          decoration:
                              widget.dropdownDecoration ??
                              BoxDecoration(
                                color: widget.dropdownBackgroundColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: widget.appendableItems!.length,
                            itemExtent: appendableItemHeight,
                            itemBuilder: (context, index) {
                              final appendableItem =
                                  widget.appendableItems![index];

                              // Wrap the appendable item to handle onTap
                              return InkWell(
                                onTap: () {
                                  // First execute the original onTap if it exists
                                  if (appendableItem is ListTile) {
                                    appendableItem.onTap?.call();
                                  }
                                  // Then close the dropdown
                                  setState(() => _isExpanded = false);
                                  _removeOverlay();
                                },
                                child: appendableItem,
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        // Basic field properties
        controller: widget.controller,
        enabled: widget.enabled,
        focusNode: widget.focusNode,
        style: widget.style,

        // Text configuration
        maxLength: widget.maxLength, // Maximum number of characters
        maxLines: widget.maxLines, // Maximum number of lines
        minLines: widget.minLines, // Minimum number of lines
        obscureText: widget.isObscured, // For password fields
        // Input handling
        keyboardType:
            widget.keyboardType, // Keyboard type (numeric, email, etc)
        inputFormatters: widget.inputFormatter, // Input validation/formatting
        validator: widget.validator, // Form validation
        // Visual customization
        decoration: widget.textFeildDecorator,
        cursorColor: widget.cursorColor,
        obscuringCharacter: widget.obscuringText,
        textAlign: widget.textAlign, // Text alignment within field
        textAlignVertical: widget.textAlignVertical, // Vertical alignment
        // Behavior settings
        autofocus: widget.autofocus, // Focus when widget is mounted
        readOnly: widget.readOnly, // Only force readonly for dropdown mode
        showCursor: widget.showCursor,
        expands: widget.expands, // Expand to fill height
        // Input actions and callbacks
        textInputAction: widget.textInputAction, // Keyboard action button
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onSubmitted,
        onTapOutside: (_) => widget.onTapOutside?.call(),

        // Advanced features
        autofillHints: widget.autofillHints, // Autofill suggestions
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,

        // Scrolling behavior
        scrollController: widget.scrollController,
        scrollPhysics: widget.scrollPhysics,
        scrollPadding: widget.scrollPadding,

        // Selection and interaction
        enableInteractiveSelection: widget.enableInteractiveSelection,
        selectionControls: widget.selectionControls,
        buildCounter: widget.buildCounter,
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,

        // Gesture and input handling
        dragStartBehavior: widget.dragStartBehavior,
        contentInsertionConfiguration: widget.contentInsertionConfiguration,
        clipBehavior: widget.clipBehavior,

        // Text suggestions and corrections
        enableSuggestions:
            widget.isDropdown
                ? false
                : widget
                    .enableSuggestions, // Enable suggestions only for text mode
        autocorrect:
            widget.isDropdown
                ? false
                : widget.autocorrect, // Enable autocorrect only for text mode
        smartDashesType:
            widget.isDropdown
                ? SmartDashesType.disabled
                : widget
                    .smartDashesType, // Enable smart dashes only for text mode
        smartQuotesType:
            widget.isDropdown
                ? SmartQuotesType.disabled
                : widget
                    .smartQuotesType, // Enable smart quotes only for text mode
        // Cursor customization
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        mouseCursor: widget.mouseCursor,

        // Dropdown functionality
        onTap:
            widget.isDropdown
                ? () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                    if (_isExpanded) {
                      _filteredItems = List.from(widget.items ?? []);
                      _page = 2;
                      _showOverlay();
                    } else {
                      _removeOverlay();
                    }
                  });
                }
                : null,
        onChanged:
            widget.isDropdown
                ? (value) {
                  filter = value;
                  if (_isExpanded) {
                    _searchData();
                  }
                }
                : (value) => widget.onChanged?.call(
                  value,
                  value,
                ), // Pass same value as both value and label for text mode
      ),
    );
  }
}
