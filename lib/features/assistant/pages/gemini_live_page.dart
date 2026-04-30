import 'package:flutter/material.dart';

import '../../../core/models/assistant.dart';
import '../../../core/providers/settings_provider.dart';
import '../widgets/gemini_live_surface.dart';

class GeminiLivePage extends StatelessWidget {
  const GeminiLivePage({
    super.key,
    required this.providerConfig,
    required this.assistant,
    this.modelId = 'gemini-2.0-flash-live-exp',
  });

  final ProviderConfig providerConfig;
  final Assistant? assistant;
  final String modelId;

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(assistant?.name.trim().isNotEmpty ?? false) ? assistant!.name.trim() : 'Assistant'} live',
            ),
            Text(
              modelId,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: navigator.maybePop, child: const Text('Close')),
          const SizedBox(width: 8),
        ],
      ),
      body: GeminiLiveSurface(
        providerConfig: providerConfig,
        assistant: assistant,
        modelId: modelId,
        autoStart: true,
      ),
    );
  }
}
