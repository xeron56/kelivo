import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  /// A text field for search based on string input
  const SearchField({
    super.key,
    required this.searchFn,
    this.hintText = "Search",
    this.autoFocus = false,
    this.initValue = "",
  });

  /// Callback function to filter and search
  final Function(String) searchFn;

  /// TextField hint text
  final String hintText;

  /// TextField autoFocus
  final bool autoFocus;

  /// TextField intial value
  final String initValue;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initValue);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    if (widget.initValue != controller.text) {
      controller.text = widget.initValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          autofocus: widget.autoFocus,
          onChanged: (term) => widget.searchFn(term),
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: controller.text.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        controller.clear(); // Clear the text field
                        widget.searchFn(''); // Reset the search
                      },
                    ),
                  )
                : const Icon(Icons.search),
            fillColor: Theme.of(context).cardColor.withValues(alpha: .7),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
