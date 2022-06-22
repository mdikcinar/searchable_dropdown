import 'package:flutter/material.dart';

class CustomInkwell extends StatelessWidget {
  final Function()? onTap;
  final EdgeInsets? padding;
  final Widget child;
  final bool disableTabEfect;
  const CustomInkwell(
      {Key? key,
      required this.onTap,
      required this.child,
      this.padding,
      this.disableTabEfect = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: disableTabEfect ? Colors.transparent : null,
      splashColor: disableTabEfect ? Colors.transparent : null,
      highlightColor: disableTabEfect ? Colors.transparent : null,
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
      child: Padding(
        padding: padding ??
            EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: child,
      ),
    );
  }
}
