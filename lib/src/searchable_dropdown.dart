import 'package:flutter/material.dart';

import 'package:searchable_paginated_dropdown/src/extensions/custom_global_key_extension.dart';
import 'package:searchable_paginated_dropdown/src/model/searchable_dropdown_menu_item.dart';
import 'package:searchable_paginated_dropdown/src/searchable_dropdown_controller.dart';
import 'package:searchable_paginated_dropdown/src/utils/custom_inkwell.dart';
import 'package:searchable_paginated_dropdown/src/utils/custom_search_bar.dart';

class SearchableDropdown<T> extends StatefulWidget {
  const SearchableDropdown({
    Key? key,
    Widget? hintText,
    Widget Function(Widget)? backgroundDecoration,
    String? searchHintText,
    Widget? noRecordText,
    double? dropDownMaxHeight,
    EdgeInsetsGeometry? margin,
    Widget? trailingIcon,
    Widget? leadingIcon,
    void Function(T?)? onChanged,
    List<SearchableDropdownMenuItem<T>>? items,
    T? value,
    bool isEnabled = true,
    VoidCallback? disabledOnTap,
  }) : this._(
          key: key,
          hintText: hintText,
          backgroundDecoration: backgroundDecoration,
          searchHintText: searchHintText,
          noRecordText: noRecordText,
          dropDownMaxHeight: dropDownMaxHeight,
          margin: margin,
          trailingIcon: trailingIcon,
          leadingIcon: leadingIcon,
          onChanged: onChanged,
          items: items,
          value: value,
          isEnabled: isEnabled,
          disabledOnTap: disabledOnTap,
        );

  const SearchableDropdown.paginated({
    required Future<List<SearchableDropdownMenuItem<T>>?> Function(int, String?)? paginatedRequest,
    int? requestItemCount,
    Key? key,
    Widget? hintText,
    Widget Function(Widget)? backgroundDecoration,
    String? searchHintText,
    Widget? noRecordText,
    double? dropDownMaxHeight,
    EdgeInsetsGeometry? margin,
    Widget? trailingIcon,
    Widget? leadingIcon,
    void Function(T?)? onChanged,
    bool isEnabled = true,
    VoidCallback? disabledOnTap,
  }) : this._(
          key: key,
          paginatedRequest: paginatedRequest,
          requestItemCount: requestItemCount,
          hintText: hintText,
          backgroundDecoration: backgroundDecoration,
          searchHintText: searchHintText,
          noRecordText: noRecordText,
          dropDownMaxHeight: dropDownMaxHeight,
          margin: margin,
          trailingIcon: trailingIcon,
          leadingIcon: leadingIcon,
          onChanged: onChanged,
          isEnabled: isEnabled,
          disabledOnTap: disabledOnTap,
        );

  const SearchableDropdown.future({
    required Future<List<SearchableDropdownMenuItem<T>>?> Function()? futureRequest,
    Key? key,
    Widget? hintText,
    Widget Function(Widget)? backgroundDecoration,
    String? searchHintText,
    Widget? noRecordText,
    double? dropDownMaxHeight,
    EdgeInsetsGeometry? margin,
    Widget? trailingIcon,
    Widget? leadingIcon,
    void Function(T?)? onChanged,
    bool isEnabled = true,
    VoidCallback? disabledOnTap,
  }) : this._(
          futureRequest: futureRequest,
          key: key,
          hintText: hintText,
          backgroundDecoration: backgroundDecoration,
          searchHintText: searchHintText,
          noRecordText: noRecordText,
          dropDownMaxHeight: dropDownMaxHeight,
          margin: margin,
          trailingIcon: trailingIcon,
          leadingIcon: leadingIcon,
          onChanged: onChanged,
          isEnabled: isEnabled,
          disabledOnTap: disabledOnTap,
        );

  const SearchableDropdown._({
    super.key,
    this.hintText,
    this.backgroundDecoration,
    this.searchHintText,
    this.noRecordText,
    this.dropDownMaxHeight,
    this.margin,
    this.trailingIcon,
    this.leadingIcon,
    this.onChanged,
    this.items,
    this.value,
    this.isEnabled = true,
    this.disabledOnTap,
    this.futureRequest,
    this.paginatedRequest,
    this.requestItemCount,
  });

  //Is dropdown enabled
  final bool isEnabled;

  /// Height of dropdown's dialog, default: MediaQuery.of(context).size.height*0.3.
  final double? dropDownMaxHeight;

  /// Dropdowns margin padding with other widgets.
  final EdgeInsetsGeometry? margin;

  /// Future service which is returns DropdownMenuItem list.
  final Future<List<SearchableDropdownMenuItem<T>>?> Function()? futureRequest;

  /// Paginated request service which is returns DropdownMenuItem list.
  final Future<List<SearchableDropdownMenuItem<T>>?> Function(int page, String? searchKey)? paginatedRequest;

  /// Paginated request item count which returns in one page, this value is using for knowledge about isDropdown has more item or not.
  final int? requestItemCount;

  /// Dropdown items.
  final List<SearchableDropdownMenuItem<T>>? items;

  /// SearchBar hint text.
  final String? searchHintText;

  //Initial value of dropdown
  final T? value;

  //Triggers this function if dropdown pressed while disabled
  final VoidCallback? disabledOnTap;

  /// Returns selected Item.
  final void Function(T? value)? onChanged;

  /// Hint text shown when the dropdown is empty.
  final Widget? hintText;

  /// Shows if there is no record found.
  final Widget? noRecordText;

  /// Dropdown trailing icon.
  final Widget? trailingIcon;

  /// Dropdown trailing icon.
  final Widget? leadingIcon;

  /// Background decoration of dropdown, i.e. with this you can wrap dropdown with Card.
  final Widget Function(Widget child)? backgroundDecoration;

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final SearchableDropdownController<T> controller = SearchableDropdownController<T>();

  @override
  void initState() {
    controller
      ..paginatedRequest = widget.paginatedRequest
      ..futureRequest = widget.futureRequest
      ..requestItemCount = widget.requestItemCount ?? 0
      ..items = widget.items
      ..searchedItems.value = widget.items;
    for (final element in widget.items ?? <SearchableDropdownMenuItem<T>>[]) {
      if (element.value == widget.value) {
        controller.selectedItem.value = element;
        return;
      }
    }
    controller.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: controller.key,
      width: MediaQuery.of(context).size.width,
      child: widget.backgroundDecoration?.call(
            _DropDown(
              controller: controller,
              isEnabled: widget.isEnabled,
              disabledOnTap: widget.disabledOnTap,
              dropDownMaxHeight: widget.dropDownMaxHeight,
              futureRequest: widget.futureRequest,
              hintText: widget.hintText,
              leadingIcon: widget.leadingIcon,
              margin: widget.margin,
              noRecordText: widget.noRecordText,
              onChanged: widget.onChanged,
              paginatedRequest: widget.paginatedRequest,
              searchHintText: widget.searchHintText,
              trailingIcon: widget.trailingIcon,
            ),
          ) ??
          _DropDown(
            controller: controller,
            isEnabled: widget.isEnabled,
            disabledOnTap: widget.disabledOnTap,
            dropDownMaxHeight: widget.dropDownMaxHeight,
            futureRequest: widget.futureRequest,
            hintText: widget.hintText,
            leadingIcon: widget.leadingIcon,
            margin: widget.margin,
            noRecordText: widget.noRecordText,
            onChanged: widget.onChanged,
            paginatedRequest: widget.paginatedRequest,
            searchHintText: widget.searchHintText,
            trailingIcon: widget.trailingIcon,
          ),
    );
  }
}

class _DropDown<T> extends StatelessWidget {
  const _DropDown({
    required this.isEnabled,
    required this.controller,
    this.leadingIcon,
    this.trailingIcon,
    this.disabledOnTap,
    this.margin,
    this.hintText,
    this.dropDownMaxHeight,
    this.futureRequest,
    this.paginatedRequest,
    this.noRecordText,
    this.onChanged,
    this.searchHintText,
  });

  final bool isEnabled;
  final double? dropDownMaxHeight;
  final EdgeInsetsGeometry? margin;
  final Future<List<SearchableDropdownMenuItem<T>>?> Function()? futureRequest;
  final Future<List<SearchableDropdownMenuItem<T>>?> Function(int page, String? searchKey)? paginatedRequest;
  final SearchableDropdownController<T> controller;
  final String? searchHintText;
  final VoidCallback? disabledOnTap;
  final void Function(T? value)? onChanged;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final Widget? hintText;
  final Widget? noRecordText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isEnabled) {
          _dropDownOnTab(context, controller);
        } else {
          disabledOnTap?.call();
        }
      },
      child: Padding(
        padding: margin ?? EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (leadingIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: leadingIcon,
                    ),
                  Flexible(
                    child: _DropDownText(
                      controller: controller,
                      hintText: hintText,
                    ),
                  ),
                ],
              ),
            ),
            trailingIcon ??
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: MediaQuery.of(context).size.height * 0.033,
                ),
          ],
        ),
      ),
    );
  }

  void _dropDownOnTab(BuildContext context, SearchableDropdownController<T> controller) {
    var isReversed = false;
    final positionFromBottom = controller.key.globalPaintBounds != null
        ? MediaQuery.of(context).size.height - controller.key.globalPaintBounds!.bottom
        : null;
    final alertDialogMaxHeight = dropDownMaxHeight ?? MediaQuery.of(context).size.height * 0.35;
    var dialogPositionFromBottom = positionFromBottom != null ? positionFromBottom - alertDialogMaxHeight : null;
    if (dialogPositionFromBottom != null) {
      //Dialog ekrana sığmıyor ise reverseler
      //If dialog couldn't fit the screen, reverse it
      if (dialogPositionFromBottom <= 0) {
        isReversed = true;
        dialogPositionFromBottom += alertDialogMaxHeight +
            controller.key.globalPaintBounds!.height +
            MediaQuery.of(context).size.height * 0.005;
      } else {
        dialogPositionFromBottom -= MediaQuery.of(context).size.height * 0.005;
      }
    }
    if (controller.items == null) {
      if (paginatedRequest != null) controller.getItemsWithPaginatedRequest(page: 1, isNewSearch: true);
      if (futureRequest != null) controller.getItemsWithFutureRequest();
    } else {
      controller.searchedItems.value = controller.items;
    }
    //Hesaplamaları yaptıktan sonra dialogu göster
    //Show the dialog
    showDialog(
      context: context,
      builder: (context) {
        var reCalculatePosition = dialogPositionFromBottom;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        //Keyboard varsa digalogu ofsetler
        //If keyboard pushes the dialog, recalculate the dialog's possition.
        if (reCalculatePosition != null && reCalculatePosition <= keyboardHeight) {
          reCalculatePosition = (keyboardHeight - reCalculatePosition) + reCalculatePosition;
        }
        return Padding(
          padding: EdgeInsets.only(
              bottom: reCalculatePosition ?? 0,
              left: MediaQuery.of(context).size.height * 0.02,
              right: MediaQuery.of(context).size.height * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: alertDialogMaxHeight,
                child: _DropDownCard(
                  controller: controller,
                  isReversed: isReversed,
                  noRecordText: noRecordText,
                  onChanged: onChanged,
                  paginatedRequest: paginatedRequest,
                  searchHintText: searchHintText,
                ),
              ),
            ],
          ),
        );
      },
      barrierDismissible: true,
      barrierColor: Colors.transparent,
    );
  }
}

class _DropDownText<T> extends StatelessWidget {
  const _DropDownText({
    required this.controller,
    this.hintText,
  });

  final SearchableDropdownController<T> controller;
  final Widget? hintText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.selectedItem,
      builder: (context, SearchableDropdownMenuItem<T>? selectedItem, child) =>
          selectedItem?.child ??
          (selectedItem?.label != null
              ? Text(selectedItem!.label, maxLines: 1, overflow: TextOverflow.fade)
              : hintText) ??
          const SizedBox.shrink(),
    );
  }
}

class _DropDownCard<T> extends StatelessWidget {
  const _DropDownCard({
    required this.isReversed,
    required this.controller,
    this.searchHintText,
    this.paginatedRequest,
    this.onChanged,
    this.noRecordText,
  });

  final bool isReversed;
  final Future<List<SearchableDropdownMenuItem<T>>?> Function(int page, String? searchKey)? paginatedRequest;
  final SearchableDropdownController<T> controller;
  final String? searchHintText;
  final void Function(T? value)? onChanged;
  final Widget? noRecordText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: isReversed ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.height * 0.015),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              verticalDirection: isReversed ? VerticalDirection.up : VerticalDirection.down,
              children: [
                _DropDownSearchBar(
                  controller: controller,
                  searchHintText: searchHintText,
                ),
                Flexible(
                  child: _DropDownListView(
                    isReversed: isReversed,
                    controller: controller,
                    noRecordText: noRecordText,
                    onChanged: onChanged,
                    paginatedRequest: paginatedRequest,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DropDownSearchBar<T> extends StatelessWidget {
  const _DropDownSearchBar({
    required this.controller,
    this.searchHintText,
  });
  final SearchableDropdownController<T> controller;
  final String? searchHintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      child: CustomSearchBar(
        focusNode: controller.searchFocusNode,
        changeCompletionDelay: const Duration(milliseconds: 200),
        hintText: searchHintText ?? 'Search',
        isOutlined: true,
        leadingIcon: Icon(Icons.search, size: MediaQuery.of(context).size.height * 0.033),
        onChangeComplete: (value) {
          controller.searchText = value;
          if (controller.items != null) {
            controller.fillSearchedList(value);
            return;
          }
          if (value == '') {
            controller.getItemsWithPaginatedRequest(page: 1, isNewSearch: true);
          } else {
            controller.getItemsWithPaginatedRequest(page: 1, key: value, isNewSearch: true);
          }
        },
      ),
    );
  }
}

class _DropDownListView<T> extends StatelessWidget {
  const _DropDownListView({
    required this.isReversed,
    required this.controller,
    this.paginatedRequest,
    this.noRecordText,
    this.onChanged,
  });

  final bool isReversed;
  final Future<List<SearchableDropdownMenuItem<T>>?> Function(int page, String? searchKey)? paginatedRequest;
  final SearchableDropdownController<T> controller;
  final void Function(T? value)? onChanged;
  final Widget? noRecordText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: paginatedRequest != null ? controller.paginatedItemList : controller.searchedItems,
      builder: (context, List<SearchableDropdownMenuItem<T>>? itemList, child) => itemList == null
          ? const Center(child: CircularProgressIndicator())
          : itemList.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
                  child: noRecordText ?? const Text('No record'),
                )
              : Scrollbar(
                  thumbVisibility: true,
                  controller: controller.scrollController,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: listViewPadding(context: context, isReversed: isReversed),
                    itemCount: itemList.length + 1,
                    shrinkWrap: true,
                    reverse: isReversed,
                    itemBuilder: (context, index) {
                      if (index < itemList.length) {
                        final item = itemList.elementAt(index);
                        return CustomInkwell(
                          child: item.child,
                          onTap: () {
                            controller.selectedItem.value = item;
                            onChanged?.call(item.value);
                            Navigator.pop(context);
                            item.onTap?.call();
                          },
                        );
                      } else {
                        return ValueListenableBuilder(
                          valueListenable: controller.status,
                          builder: (context, SearchableDropdownStatus state, child) =>
                              state == SearchableDropdownStatus.busy
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const SizedBox(),
                        );
                      }
                    },
                  ),
                ),
    );
  }

  EdgeInsets listViewPadding({required BuildContext context, required bool isReversed}) {
    return EdgeInsets.only(
      left: MediaQuery.of(context).size.height * 0.01,
      right: MediaQuery.of(context).size.height * 0.01,
      bottom: !isReversed ? MediaQuery.of(context).size.height * 0.06 : 0,
      top: isReversed ? MediaQuery.of(context).size.height * 0.06 : 0,
    );
  }
}
