import 'package:flutter/material.dart';

import 'extensions/global_key_extension.dart';
import 'model/searchable_dropdown_menu_item.dart';
import 'searchable_dropdown_controller.dart';
import 'utils/custom_inkwell.dart';
import 'utils/search_bar.dart';

// ignore: must_be_immutable
class SearchableDropdown<T> extends StatefulWidget {
  ///Hint text shown when the dropdown is empty
  final Widget? hintText;

  ///Background decoration of dropdown, i.e. with this you can wrap dropdown with Card
  final Widget Function(Widget child)? backgroundDecoration;

  ///Shwons if there is no record found
  final Widget? noRecordText;

  ///Dropdown trailing icon
  final Widget? icon;

  ///Searchbar hint text
  final String? searchHintText;

  ///Dropdowns margin padding with other widgets
  final EdgeInsetsGeometry? margin;

  ///Height of dropdown's dialog, default: MediaQuery.of(context).size.height*0.3
  final double? dropDownMaxHeight;

  ///Returns selected Item
  final void Function(T? value)? onChanged;

  ///Dropdown items
  List<SearchableDropdownMenuItem<T>>? items;

  ///Paginated or normal request service which is returns DropdownMenuItem list
  Future<List<SearchableDropdownMenuItem<T>>?> Function(int page, String? key)? getRequest;

  ///Paginated request item count which returns in one page, this value is using for knowledge about isDropdown has more item or not.
  int? requestItemCount;

  SearchableDropdown({
    Key? key,
    this.hintText,
    this.backgroundDecoration,
    this.searchHintText,
    this.noRecordText,
    this.dropDownMaxHeight,
    this.margin,
    this.icon,
    this.onChanged,
    this.items,
  }) : super(key: key);

  SearchableDropdown.paginated({
    Key? key,
    this.hintText,
    this.backgroundDecoration,
    this.searchHintText,
    this.noRecordText,
    this.dropDownMaxHeight,
    this.margin,
    this.icon,
    this.onChanged,
    required this.getRequest,
    this.requestItemCount,
  }) : super(key: key);

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  late SearcableDropdownController<T> controller;

  @override
  void initState() {
    controller = SearcableDropdownController<T>();
    controller.getRequestFunc = widget.getRequest;
    controller.requestItemCount = widget.requestItemCount ?? 0;
    controller.items = widget.items;
    controller.searchedItems.value = widget.items;
    controller.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: controller.key,
      width: MediaQuery.of(context).size.width,
      child: widget.backgroundDecoration != null
          ? widget.backgroundDecoration!(buildDropDown(controller))
          : buildDropDown(controller),
    );
  }

  GestureDetector buildDropDown(SearcableDropdownController<T> controller) {
    return GestureDetector(
      onTap: () => _dropDownOnTab(controller),
      child: Padding(
        padding: widget.margin ?? EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: Row(
          children: [
            Expanded(child: dropDownText(controller)),
            widget.icon ??
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: MediaQuery.of(context).size.height * 0.033,
                ),
          ],
        ),
      ),
    );
  }

  _dropDownOnTab(SearcableDropdownController<T> controller) {
    bool isReversed = false;
    double? possitionFromBottom = controller.key.globalPaintBounds != null
        ? MediaQuery.of(context).size.height - controller.key.globalPaintBounds!.bottom
        : null;
    double alertDialogMaxHeight = widget.dropDownMaxHeight ?? MediaQuery.of(context).size.height * 0.3;
    double? dialogPossitionFromBottom = possitionFromBottom != null ? possitionFromBottom - alertDialogMaxHeight : null;
    if (dialogPossitionFromBottom != null) {
      //Dialog ekrana sığmıyor ise reverseler
      //If dialog couldn't fit the screen, reverse it
      if (dialogPossitionFromBottom <= 0) {
        isReversed = true;
        dialogPossitionFromBottom +=
            alertDialogMaxHeight + controller.key.globalPaintBounds!.height + MediaQuery.of(context).size.height * 0.005;
      } else {
        dialogPossitionFromBottom -= MediaQuery.of(context).size.height * 0.005;
      }
    }
    if (widget.items == null) {
      controller.getRequest(page: 1, isNewSearch: true);
    }
    //Hesaplamaları yaptıktan sonra dialogu göster
    //Show the dialog
    showDialog(
      context: context,
      builder: (context) {
        double? reCalculatePosition = dialogPossitionFromBottom;
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
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
                child: _buildStatefullDropdownCard(controller, isReversed),
              ),
            ],
          ),
        );
      },
      barrierDismissible: true,
      barrierColor: Colors.transparent,
    );
  }

  Widget _buildStatefullDropdownCard(SearcableDropdownController<T> controller, bool isReversed) {
    return Column(
      mainAxisAlignment: isReversed ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.015))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              verticalDirection: isReversed ? VerticalDirection.up : VerticalDirection.down,
              children: [
                buildSearchBar(controller),
                Flexible(
                  child: buildListView(controller, isReversed),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding buildSearchBar(SearcableDropdownController controller) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      child: CustomSearchBar(
        focusNode: controller.searchFocusNode,
        changeCompletionDelay: const Duration(milliseconds: 200),
        hintText: widget.searchHintText ?? 'Search',
        isOutlined: true,
        leadingIcon: Icon(Icons.search, size: MediaQuery.of(context).size.height * 0.033),
        onChangeComplete: (value) {
          controller.searchText = value;
          if (widget.items != null) {
            controller.fillSearchedList(value);
            return;
          }
          if (value == '') {
            controller.getRequest(page: 1, isNewSearch: true);
          } else {
            controller.getRequest(page: 1, key: value, isNewSearch: true);
          }
        },
      ),
    );
  }

  Widget buildListView(SearcableDropdownController<T> controller, bool isReversed) {
    return ValueListenableBuilder(
      valueListenable: (widget.items == null ? controller.itemList : controller.searchedItems),
      builder: (context, List<SearchableDropdownMenuItem<T>>? itemList, child) => itemList == null
          ? const Center(child: CircularProgressIndicator())
          : itemList.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
                  child: widget.noRecordText ?? const Text('No record'),
                )
              : Scrollbar(
                  thumbVisibility: true,
                  controller: controller.scrollController,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: _listviewPadding(isReversed),
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
                            if (widget.onChanged != null) {
                              widget.onChanged!(item.value);
                            }
                            Navigator.pop(context);
                            if (item.onTap != null) item.onTap!();
                          },
                        );
                      } else {
                        return ValueListenableBuilder(
                          valueListenable: controller.state,
                          builder: (context, SearcableDropdownState state, child) => state == SearcableDropdownState.Busy
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

  EdgeInsets _listviewPadding(bool isReversed) {
    return EdgeInsets.only(
        left: MediaQuery.of(context).size.height * 0.01,
        right: MediaQuery.of(context).size.height * 0.01,
        bottom: !isReversed ? MediaQuery.of(context).size.height * 0.06 : 0,
        top: isReversed ? MediaQuery.of(context).size.height * 0.06 : 0);
  }

  Widget dropDownText(SearcableDropdownController<T> controller) {
    return ValueListenableBuilder(
      valueListenable: controller.selectedItem,
      builder: (context, SearchableDropdownMenuItem<T>? selectedItem, child) =>
          selectedItem?.child ??
          (selectedItem?.label != null ? Text(selectedItem!.label) : widget.hintText) ??
          const SizedBox.shrink(),
    );
  }
}
