import 'package:flutter/material.dart';

class DialogOptions {
  const DialogOptions({
    this.width,
    this.maxHeight,
    this.alignment = CrossAxisAlignment.center,
    this.horizontalPadding = 16,
  });

  /// The alignment of the dropdown dialog, default: CrossAxisAlignment.center.
  final CrossAxisAlignment alignment;

  /// The width of the dropdown dialog.
  final double? width;

  /// The maximum height of the dropdown dialog.
  final double? maxHeight;

  /// The horizontal padding of the dropdown dialog, default: 16, but it will be 0 if width is given.
  final double horizontalPadding;

  double get horizontalPaddingValue => width != null ? 0 : horizontalPadding;
}
