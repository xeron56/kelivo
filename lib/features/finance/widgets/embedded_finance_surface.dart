import 'package:finance_tracker/finance_tracker.dart';
import 'package:flutter/material.dart';

import 'finance_voice_overlay.dart';

class EmbeddedFinanceSurface extends StatelessWidget {
  const EmbeddedFinanceSurface({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        FinanceTrackerApp(embeddedInHost: true),
        FinanceVoiceOverlay(),
      ],
    );
  }
}
