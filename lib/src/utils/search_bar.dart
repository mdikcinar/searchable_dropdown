import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'custom_inkwell.dart';

class CustomSearchBar extends StatelessWidget {
  ///Cancelable operation ile klavyeden değer girme işlemi kontrol edilir
  ///Verilen delay içerisinde klavyeden yeni bir giriş olmaz ise bu fonksiyon tetiklenir.
  final Function(String value)? onChangeComplete;

  ///Klavyeden değer girme işlemi bittikten kaç milisaniye sonra on change complete fonksiyonunun tetikleneceğini belirler
  final Duration changeCompletionDelay;

  final String? hintText;
  final Widget? leadingIcon;
  final bool isOutlined;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? style;

  const CustomSearchBar({
    Key? key,
    this.onChangeComplete,
    this.changeCompletionDelay = const Duration(milliseconds: 800),
    this.hintText,
    this.leadingIcon,
    this.isOutlined = false,
    this.focusNode,
    this.controller,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode myfocusNode = focusNode ?? FocusNode();
    CancelableOperation? cancelableOpertaion;

    void _startCancelableOperation() {
      cancelableOpertaion = CancelableOperation.fromFuture(
        Future.delayed(changeCompletionDelay),
        onCancel: () {},
      );
    }

    Padding _buildTextField() {
      return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: 1,
          onChanged: (value) async {
            await cancelableOpertaion?.cancel();
            _startCancelableOperation();
            cancelableOpertaion?.value.whenComplete(() async {
              if (onChangeComplete != null) onChangeComplete!(value);
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

    return CustomInkwell(
      padding: EdgeInsets.zero,
      disableTabEfect: true,
      onTap: myfocusNode.requestFocus,
      child: isOutlined
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.01),
                border: Border.all(
                    color: (style?.color ?? Colors.black).withOpacity(0.5)),
              ),
              child: _buildTextField(),
            )
          : Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.height * 0.015))),
              child: _buildTextField(),
            ),
    );
  }
}
