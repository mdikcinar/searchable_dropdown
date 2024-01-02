import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:dio/dio.dart';

import 'model/pagination_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final dio = Dio();

  final SearchableDropdownController<int> searchableDropdownController = SearchableDropdownController<int>(
    initialItem: const SearchableDropdownMenuItem(
      value: 2,
      label: 'At',
      child: Text('At'),
    ),
  );

  @override
  void dispose() {
    searchableDropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Searchable Dropdown Example'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: SearchableDropdown<int>.future(
                hintText: const Text('Future request'),
                margin: const EdgeInsets.all(15),
                futureRequest: () async {
                  final paginatedList = await getAnimeList(page: 1, key: '');
                  return paginatedList?.animeList
                      ?.map((e) =>
                          SearchableDropdownMenuItem(value: e.malId, label: e.title ?? '', child: Text(e.title ?? '')))
                      .toList();
                },
                onChanged: (int? value) {
                  debugPrint('$value');
                },
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: SearchableDropdown<int>.paginated(
                hintText: const Text('Paginated request'),
                margin: const EdgeInsets.all(15),
                paginatedRequest: (int page, String? searchKey) async {
                  final paginatedList = await getAnimeList(page: page, key: searchKey);
                  return paginatedList?.animeList
                      ?.map((e) =>
                          SearchableDropdownMenuItem(value: e.malId, label: e.title ?? '', child: Text(e.title ?? '')))
                      .toList();
                },
                requestItemCount: 25,
                onChanged: (int? value) {
                  debugPrint('$value');
                },
              ),
            ),
            const SizedBox(height: 20),
            SearchableDropdown<int>.paginated(
              backgroundDecoration: (child) => InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  labelText: 'Pokemons',
                ),
                child: child,
              ),
              hintText: const Text('Paginated request'),
              paginatedRequest: (int page, String? searchKey) async {
                final paginatedList = await getAnimeList(page: page, key: searchKey);
                return paginatedList?.animeList
                    ?.map((e) =>
                        SearchableDropdownMenuItem(value: e.malId, label: e.title ?? '', child: Text(e.title ?? '')))
                    .toList();
              },
              requestItemCount: 25,
              onChanged: (int? value) {
                debugPrint('$value');
              },
              hasTrailingClearIcon: false,
              trailingIcon: const Icon(Icons.arrow_circle_down_outlined),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: SearchableDropdown<int>(
                hintText: const Text('List of items'),
                margin: const EdgeInsets.all(15),
                items: List.generate(
                    10, (i) => SearchableDropdownMenuItem(value: i, label: 'item $i', child: Text('item $i'))),
                onChanged: (int? value) {
                  debugPrint('$value');
                },
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                children: [
                  SearchableDropdownFormField<int>(
                    initialValue: 2,
                    backgroundDecoration: (child) => Card(
                      margin: EdgeInsets.zero,
                      color: Colors.lightBlue,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: child,
                      ),
                    ),
                    hintText: const Text('Search Anime'),
                    margin: const EdgeInsets.all(15),
                    items: List.generate(
                        10, (i) => SearchableDropdownMenuItem(value: i, label: 'item $i', child: Text('item $i'))),
                    validator: (val) {
                      if (val == null) return 'Cant be empty';
                      return null;
                    },
                    onSaved: (val) {
                      debugPrint('On save: $val');
                    },
                  ),
                  SearchableDropdownFormField<int>.paginated(
                    controller: searchableDropdownController,
                    backgroundDecoration: (child) => Card(
                      margin: EdgeInsets.zero,
                      color: Colors.amberAccent,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: child,
                      ),
                    ),
                    hintText: const Text('Search Anime'),
                    margin: const EdgeInsets.all(15),
                    paginatedRequest: (int page, String? searchKey) async {
                      final paginatedList = await getAnimeList(page: page, key: searchKey);
                      return paginatedList?.animeList
                          ?.map((e) => SearchableDropdownMenuItem(
                              value: e.malId, label: e.title ?? '', child: Text(e.title ?? '')))
                          .toList();
                    },
                    validator: (val) {
                      if (val == null) return 'Cant be empty';
                      return null;
                    },
                    onSaved: (val) {
                      debugPrint('On save: $val');
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState?.save();
                    }
                  },
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () {
                    searchableDropdownController.clear();
                  },
                  child: const Text('Clear controller'),
                ),
              ],
            ),
            const SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    child: SearchableDropdown<int>(
                      width: 200,
                      isDialogExpanded: false,
                      hintText: const Text('List of items'),
                      margin: const EdgeInsets.all(15),
                      items: List.generate(
                          10, (i) => SearchableDropdownMenuItem(value: i, label: 'item $i', child: Text('item $i'))),
                      onChanged: (int? value) {
                        debugPrint('$value');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<AnimePaginatedList?> getAnimeList({required int page, String? key}) async {
    try {
      String url = "https://api.jikan.moe/v4/anime?page=$page";
      if (key != null && key.isNotEmpty) url += "&q=$key";
      var response = await dio.get(url);
      if (response.statusCode != 200) throw Exception(response.statusMessage);
      return AnimePaginatedList.fromJson(response.data);
    } catch (exception) {
      throw Exception(exception);
    }
  }
}
