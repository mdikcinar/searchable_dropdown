import 'package:flutter/material.dart';

class SearchableDropdownMenuItem<T> {
  const SearchableDropdownMenuItem({
    required this.label,
    required this.child,
    this.value,
    this.onTap,
  });

  /// This is for searching or if child property is null this will be shown.
  final String label;

  final T? value;

  /// Item on tap.
  final VoidCallback? onTap;

  /// Dropdown item widget.
  final Widget child;
}
