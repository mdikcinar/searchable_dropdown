import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:searchable_paginated_dropdown/src/utils/custom_search_bar.dart';

import '../../helpers/helpers.dart';

void main() {
  group(CustomSearchBar, () {
    testWidgets(
        'should wait 800ms cancelableOperation time to call onChangeComplete',
        (tester) async {
      final mockCallBack = MockCallback();

      var testValue = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomSearchBar(
              onChangeComplete: (value) {
                testValue = value;
                mockCallBack.call();
              },
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      const expectedText = 'test';
      await tester.enterText(textField, expectedText);
      await tester.pump(const Duration(milliseconds: 300));
      expect(testValue, '');
      const expectedText2 = 'test2';
      await tester.enterText(textField, expectedText2);
      await tester.pump(const Duration(milliseconds: 500));
      expect(testValue, '');
      await tester.pump(const Duration(milliseconds: 300));
      expect(testValue, expectedText2);
      expect(mockCallBack.called(1), isTrue);
    });
  });
}
