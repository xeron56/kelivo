import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabeledText extends StatelessWidget {
  const LabeledText(
      {super.key, required this.label, required this.text, this.fontSize});

  final String? label;
  final String? text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: SizedBox(
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text ?? "",
                style: TextStyle(fontSize: fontSize),
              ),
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: text ?? ""));
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$label copied to clipboard"),
                        duration: const Duration(microseconds: 500),
                      ),
                    );
                  });
                  // copied successfully
                },
                constraints: const BoxConstraints(maxHeight: 36),
                splashRadius: 52,
                icon: const Icon(Icons.copy),
                iconSize: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}
