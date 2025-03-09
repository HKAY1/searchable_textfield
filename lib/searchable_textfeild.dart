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
class SearchableTextField<T> extends StatefulWidget {
  final Future<List<T>> Function({int page, String filter, int limit})?
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
    required this.isObscured,
    this.focusNode,
    this.textFeildDecorator,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.inputFormatter,
    this.obscuringText = '•',
    this.cursorColor,
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
    if (widget.getItems == null) return;

    final nextPage = _page + 1;
    final nextItems = await widget.getItems!(
      page: nextPage,
      filter: filter,
      limit: _loadSize,
    );

    if (nextItems.isNotEmpty) {
      setState(() {
        _filteredItems.removeRange(0, _loadSize);
        _filteredItems.addAll(nextItems.cast<DropdownMenuItems>());
        _page = nextPage;
      });

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.pixels -
              (MediaQuery.sizeOf(context).height * 0.3),
        );
      }
    }
  }

  Future<void> _loadPreviousPage() async {
    if (widget.getItems == null || _page < 3) return;

    final prevPage = _page - 3;
    final items = await widget.getItems!(
      page: prevPage,
      filter: filter,
      limit: _loadSize,
    );

    if (items.isNotEmpty) {
      setState(() {
        _filteredItems.insertAll(0, items.cast<DropdownMenuItems>());
        _filteredItems.removeRange(
          _filteredItems.length - _loadSize,
          _filteredItems.length,
        );
        _page -= 1;
      });

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.pixels +
              (MediaQuery.sizeOf(context).height * 0.3),
        );
      }
    }
  }

  void runDebounced(VoidCallback action) {
    _debouncer?.cancel();
    _debouncer = Timer(const Duration(milliseconds: 200), action);
  }

  void _searchData() {
    runDebounced(() async {
      if (!widget.isDropdown) return;

      if (filter.isEmpty) {
        _filteredItems = List.from(widget.items ?? []);
        setState(() => _isExpanded = true);
        return;
      }

      final data =
          widget.getItems == null
              ? _filteredItems
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
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
                      }
                    });
                  }
                  : null,
          onChanged: (value) {
            filter = value;
            _searchData();
          },
        ),
        if (_isExpanded)
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.3,
            ),
            height: MediaQuery.sizeOf(context).height * 0.3,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: CupertinoScrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredItems[index].lable),
                    onTap: () {
                      textController.text = _filteredItems[index].value;
                      widget.onChanged?.call(
                        _filteredItems[index].value.toString(),
                      );
                      setState(() => _isExpanded = false);
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
