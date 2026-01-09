import 'package:flutter/material.dart';

class TheDivider extends StatelessWidget {
  /// App level divider. Since normal divider is set transparent
  const TheDivider({
    super.key,
    this.indent = 15,
    this.thickness = 1,
  });

  final double indent;
  final double thickness;
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).disabledColor,
      thickness: thickness,
      indent: indent,
      endIndent: indent,
      height: 1,
    );
  }
}
