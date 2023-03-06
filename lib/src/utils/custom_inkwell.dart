import 'package:flutter/material.dart';

class CustomInkwell extends StatelessWidget {
  final Function()? onTap;
  final EdgeInsets? padding;
  final Widget child;
  final bool disableTabEffect;
  const CustomInkwell({
    Key? key,
    required this.onTap,
    required this.child,
    this.padding,
    this.disableTabEffect = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: disableTabEffect ? Colors.transparent : null,
      splashColor: disableTabEffect ? Colors.transparent : null,
      highlightColor: disableTabEffect ? Colors.transparent : null,
      onTap: onTap,
      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
      child: Padding(
        padding: padding ?? EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: child,
      ),
    );
  }
}
