import 'package:flutter/material.dart';

class SearchableDropdownMenuItem<T> {
  T? value;

  ///This is for searching or if child property is null this will be shwon
  String label;

  ///Dropdown item widget
  Widget child;

  ///Item on tap
  VoidCallback? onTap;

  SearchableDropdownMenuItem({
    this.value,
    required this.label,
    required this.child,
    this.onTap,
  });
}
