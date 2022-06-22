import 'package:flutter/material.dart';
import 'package:searchable_dropdown/src/model/searchable_dropdown_menu_item.dart';

// ignore: constant_identifier_names
enum SearcableDropdownState { Initial, Busy, Error, Loaded }

class SearcableDropdownController<T> {
  final ValueNotifier<SearcableDropdownState> state = ValueNotifier<SearcableDropdownState>(SearcableDropdownState.Initial);

  ScrollController scrollController = ScrollController();
  GlobalKey key = GlobalKey();
  FocusNode searchFocusNode = FocusNode();

  final ValueNotifier<SearchableDropdownMenuItem<T>?> selectedItem = ValueNotifier<SearchableDropdownMenuItem<T>?>(null);

  final ValueNotifier<List<SearchableDropdownMenuItem<T>>?> itemList = ValueNotifier<List<SearchableDropdownMenuItem<T>>?>(null);

  late Future<List<SearchableDropdownMenuItem<T>>?> Function(int page, String? key)? getRequestFunc;

  late int requestItemCount;

  late List<SearchableDropdownMenuItem<T>>? items;

  ValueNotifier<List<SearchableDropdownMenuItem<T>>?> searchedItems = ValueNotifier<List<SearchableDropdownMenuItem<T>>?>(null);

  bool _hasMoreData = true;
  int _page = 1;
  String searchText = '';

  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
        if (searchText.isNotEmpty) {
          getRequest(page: _page, key: searchText);
        } else {
          getRequest(page: _page);
        }
      }
    });
  }

  void dispose() {
    searchFocusNode.dispose();
    scrollController.dispose();
  }

  Future<void> getRequest({required int page, String? key, bool isNewSearch = false}) async {
    if (getRequestFunc == null) return;
    if (isNewSearch) {
      _page = 1;
      itemList.value = null;
      _hasMoreData = true;
    }
    if (!_hasMoreData) return;
    try {
      state.value = SearcableDropdownState.Busy;
      final response = await getRequestFunc!(page, key);
      if (response is! List<SearchableDropdownMenuItem<T>>) return;
      itemList.value ??= [];
      itemList.value = itemList.value! + response;
      if (response.length < requestItemCount) {
        _hasMoreData = false;
      } else {
        _page = _page + 1;
      }
      state.value = SearcableDropdownState.Loaded;

      debugPrint('searchable dropdown has more data: $_hasMoreData');
    } catch (exception) {
      state.value = SearcableDropdownState.Error;
      throw Exception(exception);
    }
  }

  void fillSearchedList(String? value) {
    if (value == null || value.isEmpty) searchedItems.value = items;

    List<SearchableDropdownMenuItem<T>> tempList = [];
    for (var element in items ?? <SearchableDropdownMenuItem<T>>[]) {
      if (element.label.contains(value!)) tempList.add(element);
    }
    searchedItems.value = tempList;
  }
}
