import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:vexana/vexana.dart';

import 'model/pagination_model.dart';
import 'service/network_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Searchable Dropdown Example'),
        ),
        body: Column(
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
              child: SearchableDropdownFormField<int>(
                backgroundDecoration: (child) => Card(
                  margin: EdgeInsets.zero,
                  color: Colors.red,
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
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                }
              },
              child: const Text('Save'),
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
      var response = await NetworkService.instance.networkManager.send<AnimePaginatedList, AnimePaginatedList>(
        url,
        parseModel: AnimePaginatedList(),
        method: RequestType.GET,
      );
      if (response.error != null) throw Exception(response.error);
      return response.data;
    } catch (exception) {
      throw Exception(exception);
    }
  }
}
