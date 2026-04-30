import 'package:flutter/material.dart';
import 'package:focus/focus.dart';

class EmbeddedFocusSurface extends StatelessWidget {
  const EmbeddedFocusSurface({super.key});

  @override
  Widget build(BuildContext context) {
    return const FocusModulePage(embeddedInHost: true);
  }
}
