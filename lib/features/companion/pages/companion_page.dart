import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../../../core/models/companion_task.dart';
import '../../../core/services/daily_companion_service.dart';

class CompanionPage extends StatefulWidget {
  const CompanionPage({super.key});

  @override
  State<CompanionPage> createState() => _CompanionPageState();
}

class _CompanionPageState extends State<CompanionPage> {
  final TextEditingController _taskCtrl = TextEditingController();
  final FocusNode _taskFocus = FocusNode();
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  // Companion window size constants
  static const double _panelW = 360;
  static const double _panelH = 560;

  @override
  void initState() {
    super.initState();
    _clockTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _now = DateTime.now()));
    _enterCompanionMode();
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _taskCtrl.dispose();
    _taskFocus.dispose();
    super.dispose();
  }

  Future<void> _enterCompanionMode() async {
    try {
      await windowManager.setSize(const Size(_panelW, _panelH));
      await windowManager.setAlwaysOnTop(true);
      await windowManager.setResizable(false);
      // Position bottom-right of screen
      final display = await windowManager.getBounds();
      final screenH = display.height;
      final screenW = display.width;
      await windowManager.setPosition(
        Offset(screenW - _panelW - 24, screenH - _panelH - 48),
      );
    } catch (_) {}
  }

  Future<void> _exitCompanionMode(BuildContext context) async {
    try {
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setResizable(true);
      await windowManager.setSize(const Size(1100, 720));
      await windowManager.center();
    } catch (_) {}
    if (context.mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final companion = context.watch<DailyCompanionService>();

    final String hour = _now.hour.toString().padLeft(2, '0');
    final String minute = _now.minute.toString().padLeft(2, '0');
    final String greeting = _greeting(_now.hour);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1C1C2E)
              : const Color(0xFFF5F5FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // ── Title bar (drag + close) ────────────────────────────────────
            _DragHandle(
              onClose: () => _exitCompanionMode(context),
            ),

            // ── Clock + greeting ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$hour:$minute',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          color: cs.primary,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          _dateLabel(_now),
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          greeting,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      _VoiceButton(
                        onTap: () => companion.speak(
                          '$greeting! Have a great day. '
                          'You have ${companion.tasks.where((t) => !t.completed).length} tasks pending.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              thickness: 0.5,
              color: cs.outlineVariant.withValues(alpha: 0.25),
              indent: 20,
              endIndent: 20,
            ),

            // ── Task list ──────────────────────────────────────────────────
            Expanded(
              child: _TaskList(companion: companion),
            ),

            // ── Add task input ─────────────────────────────────────────────
            _AddTaskBar(
              controller: _taskCtrl,
              focusNode: _taskFocus,
              onAdd: (text) async {
                await companion.addTask(text);
                _taskCtrl.clear();
              },
            ),

            // ── Bottom bar (settings row) ──────────────────────────────────
            _BottomBar(companion: companion),
          ],
        ),
      ),
    );
  }

  static String _greeting(int hour) {
    if (hour < 12) return 'Good morning! ☀️';
    if (hour < 17) return 'Good afternoon! 🌤';
    return 'Good evening! 🌙';
  }

  static String _dateLabel(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekday = days[dt.weekday - 1];
    return '$weekday, ${months[dt.month - 1]} ${dt.day}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) => windowManager.startDragging(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 6),
        child: Row(
          children: [
            Icon(Icons.wb_sunny_outlined, size: 18, color: cs.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'My Day',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close_rounded, size: 18, color: cs.onSurface.withValues(alpha: 0.5)),
              onPressed: onClose,
              tooltip: 'Back to main app',
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceButton extends StatelessWidget {
  const _VoiceButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.mic_none_rounded, size: 18, color: cs.primary),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({required this.companion});
  final DailyCompanionService companion;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tasks = companion.tasks;
    final pending = tasks.where((t) => !t.completed).toList();
    final done = tasks.where((t) => t.completed).toList();

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 40, color: cs.outlineVariant),
            const SizedBox(height: 10),
            Text(
              'No tasks yet.\nAdd something to get started!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      children: [
        if (pending.isNotEmpty) ...[
          _sectionLabel(context, '${pending.length} pending'),
          ...pending.map((t) => _TaskTile(task: t, companion: companion)),
        ],
        if (done.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _sectionLabel(context, '${done.length} completed')),
              TextButton(
                onPressed: () => companion.clearCompleted(),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Clear',
                  style: TextStyle(fontSize: 12, color: cs.error),
                ),
              ),
            ],
          ),
          ...done.map((t) => _TaskTile(task: t, companion: companion)),
        ],
      ],
    );
  }

  static Widget _sectionLabel(BuildContext context, String text) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 4, top: 2),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: cs.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task, required this.companion});
  final CompanionTask task;
  final DailyCompanionService companion;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: cs.error.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline_rounded, color: cs.error, size: 20),
      ),
      onDismissed: (_) => companion.deleteTask(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          leading: GestureDetector(
            onTap: () => companion.toggleTask(task.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.completed
                    ? cs.primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                border: Border.all(
                  color: task.completed ? cs.primary : cs.outlineVariant,
                  width: 1.5,
                ),
              ),
              child: task.completed
                  ? Icon(Icons.check_rounded, size: 14, color: cs.primary)
                  : null,
            ),
          ),
          title: Text(
            task.text,
            style: TextStyle(
              fontSize: 14,
              color: task.completed
                  ? cs.onSurface.withValues(alpha: 0.4)
                  : cs.onSurface,
              decoration: task.completed ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddTaskBar extends StatelessWidget {
  const _AddTaskBar({
    required this.controller,
    required this.focusNode,
    required this.onAdd,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final Future<void> Function(String) onAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.add_rounded, size: 20, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Add a task...',
                hintStyle: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.35),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (text) => onAdd(text),
              textInputAction: TextInputAction.done,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.send_rounded, size: 18, color: cs.primary),
            onPressed: () => onAdd(controller.text),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.companion});
  final DailyCompanionService companion;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Row(
        children: [
          // Launch at login toggle
          Icon(Icons.power_settings_new_rounded, size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            'Launch at login',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
          const SizedBox(width: 6),
          _MiniSwitch(
            value: companion.launchAtLogin,
            onChanged: (v) => companion.setLaunchAtLogin(v),
          ),
          const Spacer(),
          // Companion enabled toggle
          Icon(Icons.notifications_none_rounded, size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 4),
          _MiniSwitch(
            value: companion.enabled,
            onChanged: (v) => companion.setEnabled(v),
          ),
          const SizedBox(width: 4),
          Text(
            'Reminders',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _MiniSwitch extends StatelessWidget {
  const _MiniSwitch({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 32,
        height: 18,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: value
              ? cs.primary
              : cs.outlineVariant.withValues(alpha: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            alignment:
                value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
