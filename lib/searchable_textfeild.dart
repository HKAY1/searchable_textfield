// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchable_textfeild/dropdown_menu_items.dart';

/// [SearchableTextField] is a custom textfield widget that can function as a standard textfield
/// or a dropdown with search functionality.
///
/// - If used as a dropdown with search, [getItems] should be defined for API-based search.
/// - [items] should be provided if using predefined dropdown values.
/// - Supports pagination for handling large datasets.
/// TODO: Add Multi select support.
/// TODO: Add loading indicator.
/// TODO: Add empty state.
/// TODO: Add all textfeild parameters.
/// TODO: Add on menu item selected callback.

class SearchableTextField<T> extends StatefulWidget {
  final Future<List<T>> Function({int? page, String? filter, int? limit})?
  getItems;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final List<DropdownMenuItems>? items;
  final Function(String? val)? onChanged;
  final bool enabled;
  final bool isDropdown;
  final TextStyle? style;
  final bool isObscured;
  final FocusNode? focusNode;
  final InputDecoration? textFeildDecorator;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final String obscuringText;
  final Color? cursorColor;
  final BoxDecoration? dropdownDecoration;
  final TextStyle? dropdownItemStyle;
  final Color? dropdownBackgroundColor;
  final EdgeInsetsGeometry dropdownItemPadding;
  final double? dropdownElevation;
  final Widget? loadingWidget;
  final Color? loadingIndicatorColor;
  final double loadingIndicatorSize;
  final double loadingIndicatorStrokeWidth;
  final List<Widget>? appendableItems;

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
  }) : assert(
         !(isDropdown && (items == null || items == const [])),
         'Items cannot be empty when isDropdown is true.',
       );

  @override
  State<SearchableTextField> createState() => _SearchableTextFieldState();
}

class _SearchableTextFieldState extends State<SearchableTextField> {
  final TextEditingController textController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    textController.text = widget.controller.text;
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
    textController.dispose();
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
                                return InkWell(
                                  onTap: () {
                                    textController.text =
                                        _filteredItems[index].value;
                                    widget.onChanged?.call(
                                      _filteredItems[index].value.toString(),
                                    );
                                    setState(() => _isExpanded = false);
                                    _removeOverlay();
                                  },
                                  child: Padding(
                                    padding: widget.dropdownItemPadding,
                                    child: Text(
                                      _filteredItems[index].lable,
                                      style: widget.dropdownItemStyle,
                                    ),
                                  ),
                                );
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
                              return widget.appendableItems![index];
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: textController,
            enabled: widget.enabled,
            focusNode: widget.focusNode,
            cursorColor: widget.cursorColor,
            style: widget.style,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            obscureText: widget.isObscured,
            decoration: widget.textFeildDecorator,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatter,
            obscuringCharacter: widget.obscuringText,
            validator: widget.validator,
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
            onChanged: (value) {
              filter = value;
              if (_isExpanded) {
                _searchData();
              }
            },
          ),
        ],
      ),
    );
  }
}
