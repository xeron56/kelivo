import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'desktop_nav_rail.dart';
import 'desktop_chat_page.dart';
import 'codex_home_landing_page.dart';
import 'window_title_bar.dart';
import 'desktop_settings_page.dart';
import 'desktop_translate_page.dart';
import '../features/settings/pages/storage_space_page.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:async';
import 'hotkeys/hotkey_event_bus.dart';
import 'package:provider/provider.dart';
import '../core/providers/assistant_provider.dart';
import '../core/providers/settings_provider.dart';
import '../core/models/assistant.dart';
import '../core/services/api/gemini_live_session_service.dart';

import 'hotkeys/chat_action_bus.dart';
import '../features/assistant/widgets/gemini_live_surface.dart';
import '../features/finance/widgets/embedded_finance_surface.dart';
import '../features/focus/widgets/embedded_focus_surface.dart';
import '../features/home/utils/model_display_helper.dart';

/// Desktop home screen: left compact rail + main content.
/// Phase 1 focuses on structure and platform-appropriate interactions/hover.
class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({
    super.key,
    this.initialTabIndex,
    this.initialProviderKey,
  });

  final int?
  initialTabIndex; // 0=Chat,1=Translate,2=Storage,3=Focus,4=Live,5=Settings,6=Finance
  final String? initialProviderKey;

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  int _tabIndex =
      0; // 0=Chat, 1=Translate, 2=Storage, 3=Focus, 4=Live, 5=Settings, 6=Finance
  bool _storageVisited = false;
  late bool _showLanding;

  StreamSubscription<HotkeyAction>? _hotkeySub;

  @override
  void initState() {
    super.initState();
    _showLanding = widget.initialTabIndex == null;
    if (widget.initialTabIndex != null) {
      _tabIndex = widget.initialTabIndex!.clamp(0, 6);
    }
    _storageVisited = _tabIndex == 2;
    // 初始进入时如果就是聊天页，则聚焦聊天输入框
    if (_tabIndex == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ChatActionBus.instance.fire(ChatAction.focusInput);
      });
    }
    // Listen to global hotkey actions affecting the main tabs/window
    _hotkeySub = HotkeyEventBus.instance.stream.listen((action) async {
      switch (action) {
        case HotkeyAction.openSettings:
          if (mounted) {
            setState(() {
              _showLanding = false;
              _tabIndex = 5;
            });
          }
          break;
        case HotkeyAction.closeWindow:
          try {
            await windowManager.close();
          } catch (_) {}
          break;
        case HotkeyAction.toggleAppVisibility:
          try {
            final visible = await windowManager.isVisible();
            final minimized = await windowManager.isMinimized();
            final focused = await windowManager.isFocused();

            // 优先级：
            // 1. 如果窗口不可见或最小化，则显示并聚焦
            // 2. 如果窗口可见但未聚焦，则聚焦
            // 3. 如果窗口可见且已聚焦，则隐藏
            if (!visible || minimized) {
              await windowManager.show();
              await windowManager.focus();
              // 如果当前是聊天页，显示窗口时聚焦输入框
              if (_tabIndex == 0) {
                ChatActionBus.instance.fire(ChatAction.focusInput);
              }
            } else if (!focused) {
              await windowManager.focus();
              // 如果当前是聊天页，聚焦窗口时也聚焦输入框
              if (_tabIndex == 0) {
                ChatActionBus.instance.fire(ChatAction.focusInput);
              }
            } else {
              await windowManager.hide();
            }
          } catch (_) {}
          break;
        case HotkeyAction.newTopic:
          if (_tabIndex == 0) {
            ChatActionBus.instance.fire(ChatAction.newTopic);
          }
          break;
        case HotkeyAction.switchModel:
          if (_tabIndex == 0) {
            ChatActionBus.instance.fire(ChatAction.switchModel);
          }
          break;
        case HotkeyAction.toggleLeftPanelAssistants:
          if (_tabIndex == 0) {
            ChatActionBus.instance.fire(ChatAction.toggleLeftPanelAssistants);
          }
          break;
        case HotkeyAction.toggleLeftPanelTopics:
          if (_tabIndex == 0) {
            ChatActionBus.instance.fire(ChatAction.toggleLeftPanelTopics);
          }
          break;
      }
    });
  }

  Future<void> _submitFromLanding(
    String prompt,
    LandingAppTarget appTarget,
  ) async {
    if (appTarget.id == 'finance') {
      final ap = context.read<AssistantProvider>();
      await ap.ensureDefaults(context);
      final financeAssistant = ap.financeAssistant;
      if (financeAssistant != null) {
        await ap.setCurrentAssistant(financeAssistant.id);
      }
    }
    if (!mounted) return;
    setState(() {
      _showLanding = false;
      _tabIndex = 0;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatActionBus.instance.sendPrompt(prompt);
    });
  }

  void _openPreviousFromLanding() {
    setState(() {
      _showLanding = false;
      _tabIndex = 0;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatActionBus.instance.fire(ChatAction.focusInput);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure a reasonable min size to avoid overflow on aggressive resize.
    const minWidth = 960.0;
    const minHeight = 640.0;

    final isWindows = defaultTargetPlatform == TargetPlatform.windows;

    final assistantProvider = context.watch<AssistantProvider>();
    final bool isFinanceAssistantSelected = assistantProvider
        .isFinanceAssistantId(assistantProvider.currentAssistantId);
    final int navActiveIndex = (_tabIndex == 0 && isFinanceAssistantSelected)
        ? 7
        : (_showLanding ? -1 : _tabIndex);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final needsWidthPad = w < minWidth;
        final needsHeightPad = h < minHeight;

        Widget body = _showLanding
            ? CodexHomeLandingPage(
                onSubmit: _submitFromLanding,
                onOpenPrevious: _openPreviousFromLanding,
                onOpenFullApp: _openPreviousFromLanding,
                onOpenLiveMode: () => setState(() {
                  _showLanding = false;
                  _tabIndex = 4;
                }),
              )
            : Row(
                children: [
                  DesktopNavRail(
                    activeIndex: navActiveIndex,
                    onTapHome: () {
                      setState(() => _showLanding = true);
                    },
                    onTapChat: () {
                      setState(() {
                        _showLanding = false;
                        _tabIndex = 0;
                      });
                      // 切换到聊天页时聚焦输入框
                      ChatActionBus.instance.fire(ChatAction.focusInput);
                    },
                    onTapTranslate: () => setState(() {
                      _showLanding = false;
                      _tabIndex = 1;
                    }),
                    onTapStorage: () => setState(() {
                      _showLanding = false;
                      _tabIndex = 2;
                      _storageVisited = true;
                    }),
                    onTapFocus: () => setState(() {
                      _showLanding = false;
                      _tabIndex = 3;
                    }),
                    onTapLive: () => setState(() {
                      _showLanding = false;
                      _tabIndex = 4;
                    }),
                    onTapSettings: () {
                      setState(() {
                        _showLanding = false;
                        _tabIndex = 5;
                      });
                    },
                    onTapFinance: () => setState(() {
                      _showLanding = false;
                      _tabIndex = 6;
                    }),
                    onTapFinanceAssistant: () async {
                      final ap = context.read<AssistantProvider>();
                      await ap.ensureDefaults(context);
                      final financeAssistant = ap.financeAssistant;
                      if (financeAssistant != null) {
                        await ap.setCurrentAssistant(financeAssistant.id);
                      }
                      if (!mounted) return;
                      setState(() {
                        _showLanding = false;
                        _tabIndex = 0;
                      });
                      ChatActionBus.instance.fire(ChatAction.focusInput);
                    },
                  ),
                  Expanded(
                    // Keep all pages alive so ongoing chat streams are not canceled
                    // when switching tabs (Chat/Translate/Settings) on desktop.
                    child: IndexedStack(
                      index: _tabIndex,
                      children: [
                        // Chat page remains mounted
                        const DesktopChatPage(),
                        // Translate page remains mounted
                        const DesktopTranslatePage(
                          key: ValueKey('translate_page'),
                        ),
                        _storageVisited
                            ? const StorageSpacePage(
                                key: ValueKey('storage_space_page'),
                                embedded: true,
                              )
                            : const SizedBox.shrink(),
                        EmbeddedFocusSurface(
                          onBackToMainApp: () {
                            setState(() {
                              _showLanding = true;
                            });
                          },
                        ),
                        const _DesktopLiveAssistantTab(),
                        DesktopSettingsPage(
                          key: const ValueKey('settings_page'),
                          initialProviderKey: widget.initialProviderKey,
                        ),
                        const EmbeddedFinanceSurface(),
                      ],
                    ),
                  ),
                ],
              );

        // Wrap with Windows custom title bar when on Windows platform.
        final content = isWindows
            ? Column(
                children: [
                  WindowTitleBar(
                    leftChildren: [
                      SizedBox(width: DesktopNavRail.width / 2 - 8 - 6 - 12),
                      const _TitleBarLeading(),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        body,
                        // Inject the lazily-built settings page into the IndexedStack when needed
                        // to pass initialProviderKey without dropping chat state.
                        if (_tabIndex == 5) const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              )
            : body;

        // if (!needsWidthPad && !needsHeightPad) return content;

        // Center a constrained area if window is smaller than our minimum
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: minWidth,
              minHeight: minHeight,
            ),
            child: SizedBox(
              width: needsWidthPad ? minWidth : w,
              height: needsHeightPad ? minHeight : h,
              child: content,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    try {
      _hotkeySub?.cancel();
    } catch (_) {}
    super.dispose();
  }
}

class _DesktopLiveAssistantTab extends StatelessWidget {
  const _DesktopLiveAssistantTab();

  bool _isGeminiLiveCapable(ProviderConfig? config) {
    if (config == null) {
      return false;
    }
    if (config.apiKey.trim().isEmpty) {
      return false;
    }
    final ProviderKind kind = ProviderConfig.classify(
      config.id,
      explicitType: config.providerType,
    );
    return kind == ProviderKind.google && config.vertexAI != true;
  }

  ProviderConfig? _resolveGeminiLiveConfig(
    SettingsProvider settings,
    Assistant? assistant,
  ) {
    final ProviderConfig? active = getActiveProviderConfig(
      settings,
      assistant: assistant,
    );
    if (_isGeminiLiveCapable(active)) {
      return active;
    }

    for (final ProviderConfig config in settings.providerConfigs.values) {
      if (_isGeminiLiveCapable(config)) {
        return config;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = context.watch<SettingsProvider>();
    final Assistant? assistant = context
        .watch<AssistantProvider>()
        .currentAssistant;
    final ProviderConfig? liveConfig = _resolveGeminiLiveConfig(
      settings,
      assistant,
    );
    final ColorScheme cs = Theme.of(context).colorScheme;

    if (liveConfig == null) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.18),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.graphic_eq_rounded, size: 36, color: cs.primary),
                    const SizedBox(height: 14),
                    Text(
                      'Live voice is not configured yet.',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add a Google provider with a Gemini API key, then open this tab again.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GeminiLiveSurface(
      providerConfig: liveConfig,
      assistant: assistant,
      modelId: GeminiLiveSessionService.defaultModelId,
      autoStart: false,
      showHeader: true,
    );
  }
}

// No extra router/shim; we import DesktopSettingsPage directly above.

class _TitleBarLeading extends StatelessWidget {
  const _TitleBarLeading();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App icon
        Image.asset(
          'assets/icons/kelivo.png',
          width: 16,
          height: 16,
          filterQuality: FilterQuality.medium,
        ),
        const SizedBox(width: 8),
        // App name
        Text(
          'Kelivo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: cs.onSurface.withValues(alpha: 0.8),
            // Avoid accidental underline when not under a Material ancestor in edge cases
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
