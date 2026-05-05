import 'package:flutter/material.dart';
import 'package:focus/focus.dart';

class EmbeddedFocusSurface extends StatelessWidget {
  const EmbeddedFocusSurface({super.key, this.onBackToMainApp});

  final VoidCallback? onBackToMainApp;

  @override
  Widget build(BuildContext context) {
    return FocusModulePage(embeddedInHost: true, onExitHost: onBackToMainApp);
  }
}
