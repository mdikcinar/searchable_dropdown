import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get deviceHeight => MediaQuery.of(this).size.height;
}
