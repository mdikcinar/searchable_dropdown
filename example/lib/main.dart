import 'package:example/view/searchable_dropdown_example_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Searchable Dropdown Example'),
        ),
        body: Column(
          children: const [
            SearchAbleDropdownExampleView(),
          ],
        ),
      ),
    );
  }
}
