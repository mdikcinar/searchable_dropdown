import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/src/extensions/extensions.dart';
import 'package:searchable_paginated_dropdown/src/model/searchable_dropdown_menu_item.dart';

// Enum must be before that class.
// ignore: prefer-match-file-name
enum SearchableDropdownStatus { initial, busy, error, loaded }

class SearchableDropdownController<T> {
  FocusNode searchFocusNode = FocusNode();
  GlobalKey key = GlobalKey();
  ScrollController scrollController = ScrollController();
  final ValueNotifier<List<SearchableDropdownMenuItem<T>>?> paginatedItemList =
      ValueNotifier<List<SearchableDropdownMenuItem<T>>?>(null);
  final ValueNotifier<SearchableDropdownMenuItem<T>?> selectedItem =
      ValueNotifier<SearchableDropdownMenuItem<T>?>(null);
  final ValueNotifier<SearchableDropdownStatus> status =
      ValueNotifier<SearchableDropdownStatus>(SearchableDropdownStatus.initial);

  late Future<List<SearchableDropdownMenuItem<T>>?> Function(
      int page, String? key,)? paginatedRequest;
  late Future<List<SearchableDropdownMenuItem<T>>?> Function()? futureRequest;

  late int requestItemCount;

  late List<SearchableDropdownMenuItem<T>>? items;

  String searchText = '';
  ValueNotifier<List<SearchableDropdownMenuItem<T>>?> searchedItems =
      ValueNotifier<List<SearchableDropdownMenuItem<T>>?>(null);

  bool _hasMoreData = true;
  int _page = 1;

  Future<void> getItemsWithPaginatedRequest(
      {required int page, String? key, bool isNewSearch = false,}) async {
    if (paginatedRequest == null) return;
    if (isNewSearch) {
      _page = 1;
      paginatedItemList.value = null;
      _hasMoreData = true;
    }
    if (!_hasMoreData) return;
    status.value = SearchableDropdownStatus.busy;
    final response = await paginatedRequest!(page, key);
    if (response is! List<SearchableDropdownMenuItem<T>>) return;

    paginatedItemList.value ??= [];
    paginatedItemList.value = paginatedItemList.value! + response;
    if (response.length < requestItemCount) {
      _hasMoreData = false;
    } else {
      _page = _page + 1;
    }
    status.value = SearchableDropdownStatus.loaded;
    debugPrint('searchable dropdown has more data: $_hasMoreData');
  }

  Future<void> getItemsWithFutureRequest() async {
    if (futureRequest == null) return;

    status.value = SearchableDropdownStatus.busy;
    final response = await futureRequest!();
    if (response is! List<SearchableDropdownMenuItem<T>>) return;
    items = response;
    searchedItems.value = response;
    status.value = SearchableDropdownStatus.loaded;
  }

  void fillSearchedList(String? value) {
    if (value == null || value.isEmpty) searchedItems.value = items;

    final tempList = <SearchableDropdownMenuItem<T>>[];
    for (final element in items ?? <SearchableDropdownMenuItem<T>>[]) {
      if (element.label.containsWithTurkishChars(value!)) tempList.add(element);
    }
    searchedItems.value = tempList;
  }

  void initialize() {
    if (paginatedRequest == null) return;
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        if (searchText.isNotEmpty) {
          getItemsWithPaginatedRequest(page: _page, key: searchText);
        } else {
          getItemsWithPaginatedRequest(page: _page);
        }
      }
    });
  }

  void dispose() {
    searchFocusNode.dispose();
    scrollController.dispose();
  }
}
