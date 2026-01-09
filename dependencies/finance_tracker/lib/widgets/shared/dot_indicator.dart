import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  /// Checks whether is the selected one
  final bool isActive;

  /// Callback function on touch
  final Function onTap;

  /// The dot indicator for slides
  const DotsIndicator({
    super.key,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: isActive ? 14 : 8,
        height: isActive ? 14 : 8,
        decoration: BoxDecoration(
          color:
              isActive ? Theme.of(context).primaryColor : Colors.grey.shade400,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
