import 'dart:async';

import 'package:flutter/material.dart';

extension ScrollControllerExtension on ScrollController {
  void onBottomReach(
    VoidCallback callback, {
    double sensitivity = 100.0,
    Duration throttleDuration = const Duration(milliseconds: 200),
  }) {
    Timer? timer;

    addListener(() {
      if (timer != null) return;

      timer = Timer(throttleDuration, () => timer = null);

      final maxScroll = position.maxScrollExtent;
      final currentScroll = position.pixels;
      if (maxScroll - currentScroll <= sensitivity) {
        callback();
      }
    });
  }
}
