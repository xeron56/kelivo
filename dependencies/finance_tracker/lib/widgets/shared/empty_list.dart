import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    super.key,
    this.items = "items",
    this.addFn,
    this.isListFiltered = false,
  });

  final String items;
  final Function? addFn;
  final bool isListFiltered;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isListFiltered ? Icons.manage_search_sharp : Icons.view_list_rounded,
          size: 92,
        ),
        Text(
          isListFiltered
              ? "No ${items.toLowerCase()} found"
              : "You don't have any ${items.toLowerCase()} yet",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 24,
        ),
        Visibility(
            visible: addFn != null,
            child: TextButton(
                    style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.all(18))),
                    onPressed: () {
                      addFn?.call();
                    },
                    child: Text(
                      "Click here to add",
                      style: Theme.of(context).textTheme.titleMedium,
                    ))
                .animate(delay: 600.ms)
                .fade(curve: Curves.easeInOut, duration: 200.ms))
      ],
    )
        .animate(delay: 100.ms)
        .scale(begin: const Offset(1.10, 1.10), duration: 100.ms)
        .fade(curve: Curves.easeInOut, duration: 200.ms);
  }
}
