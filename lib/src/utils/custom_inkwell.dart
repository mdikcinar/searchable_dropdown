import 'package:flutter/material.dart';

class CustomInkwell extends StatelessWidget {
  const CustomInkwell({
    required this.onTap,
    required this.child,
    super.key,
    this.padding,
    this.disableTabEffect = false,
  });

  final bool disableTabEffect;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: disableTabEffect ? Colors.transparent : null,
      splashColor: disableTabEffect ? Colors.transparent : null,
      highlightColor: disableTabEffect ? Colors.transparent : null,
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}
