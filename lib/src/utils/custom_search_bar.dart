import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'package:searchable_paginated_dropdown/src/utils/custom_inkwell.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.onChangeComplete,
    this.changeCompletionDelay = const Duration(milliseconds: 800),
    this.hintText,
    this.leadingIcon,
    this.isOutlined = false,
    this.focusNode,
    this.controller,
    this.style,
  });

  /// Klavyeden değer girme işlemi bittikten kaç milisaniye sonra on change complete fonksiyonunun tetikleneceğini belirler.
  final bool isOutlined;
  final Duration changeCompletionDelay;
  final FocusNode? focusNode;
  final String? hintText;
  final TextEditingController? controller;
  final TextStyle? style;

  /// Cancelable operation ile klavyeden değer girme işlemi kontrol edilir.
  /// Verilen delay içerisinde klavyeden yeni bir giriş olmaz ise bu fonksiyon tetiklenir.
  final void Function(String value)? onChangeComplete;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final myFocusNode = focusNode ?? FocusNode();

    return CustomInkwell(
      padding: EdgeInsets.zero,
      disableTabEffect: true,
      onTap: myFocusNode.requestFocus,
      child: isOutlined
          ? DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: (style?.color ?? Colors.black).withOpacity(0.5),
                ),
              ),
              child: _SearchBarTextField(
                onChangeComplete: onChangeComplete,
                changeCompletionDelay: changeCompletionDelay,
                hintText: hintText,
                leadingIcon: leadingIcon,
                focusNode: focusNode,
                controller: controller,
                style: style,
              ),
            )
          : Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: _SearchBarTextField(
                onChangeComplete: onChangeComplete,
                changeCompletionDelay: changeCompletionDelay,
                hintText: hintText,
                leadingIcon: leadingIcon,
                focusNode: focusNode,
                controller: controller,
                style: style,
              ),
            ),
    );
  }
}

class _SearchBarTextField extends StatelessWidget {
  const _SearchBarTextField({
    this.onChangeComplete,
    this.changeCompletionDelay = const Duration(milliseconds: 800),
    this.hintText,
    this.leadingIcon,
    this.focusNode,
    this.controller,
    this.style,
  });

  final Duration changeCompletionDelay;
  final FocusNode? focusNode;
  final String? hintText;
  final TextEditingController? controller;
  final TextStyle? style;
  final void Function(String value)? onChangeComplete;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    // Future.delayed return Future<dynamic>
    //ignore: avoid-dynamic
    CancelableOperation<dynamic>? cancelableOperation;

    void startCancelableOperation() {
      cancelableOperation = CancelableOperation.fromFuture(
        Future.delayed(changeCompletionDelay),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: (value) async {
          await cancelableOperation?.cancel();
          startCancelableOperation();
          await cancelableOperation?.value.whenComplete(() {
            onChangeComplete?.call(value);
          });
        },
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          isDense: true,
          border: InputBorder.none,
          hintText: hintText,
          icon: leadingIcon,
        ),
      ),
    );
  }
}
