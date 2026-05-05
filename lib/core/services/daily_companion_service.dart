import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/companion_task.dart';

/// Companion service: startup greeting, 9:30 AM lunch reminder, task list.
class DailyCompanionService extends ChangeNotifier {
  DailyCompanionService._();
  static final DailyCompanionService instance = DailyCompanionService._();

  static const String _tasksKey = 'companion_tasks_v1';
  static const String _launchAtLoginKey = 'companion_launch_at_login_v1';
  static const String _enabledKey = 'companion_enabled_v1';
  static const MethodChannel _channel =
      MethodChannel('app.companion.launch_at_login');

  final FlutterTts _tts = FlutterTts();
  final _uuid = const Uuid();

  List<CompanionTask> _tasks = <CompanionTask>[];
  List<CompanionTask> get tasks => List.unmodifiable(_tasks);

  bool _enabled = true;
  bool get enabled => _enabled;

  bool _launchAtLogin = false;
  bool get launchAtLogin => _launchAtLogin;

  bool _greeted = false;
  Timer? _reminderTimer;

  bool get isDesktopMac =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> init() async {
    await _loadPrefs();
    await _initTts();
    if (_enabled) {
      _startReminderTimer();
      if (!_greeted) {
        await Future.delayed(const Duration(seconds: 2));
        await _speakStartupGreeting();
        _greeted = true;
      }
    }
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    _tts.stop();
    super.dispose();
  }

  // ── Tasks ──────────────────────────────────────────────────────────────────

  Future<void> addTask(String text) async {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _tasks.add(CompanionTask(
      id: _uuid.v4(),
      text: trimmed,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
    await _saveTasks();
  }

  Future<void> toggleTask(String id) async {
    final int idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _tasks[idx] = _tasks[idx].copyWith(completed: !_tasks[idx].completed);
    notifyListeners();
    await _saveTasks();
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    await _saveTasks();
  }

  Future<void> clearCompleted() async {
    _tasks.removeWhere((t) => t.completed);
    notifyListeners();
    await _saveTasks();
  }

  // ── Settings ───────────────────────────────────────────────────────────────

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, value);
    if (value) {
      _startReminderTimer();
    } else {
      _reminderTimer?.cancel();
    }
  }

  Future<void> setLaunchAtLogin(bool value) async {
    _launchAtLogin = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_launchAtLoginKey, value);
    if (isDesktopMac) {
      try {
        await _channel.invokeMethod<void>(
          'setLaunchAtLogin',
          <String, dynamic>{'enabled': value},
        );
      } catch (e) {
        debugPrint('[Companion] launch-at-login channel error: $e');
      }
    }
  }

  // ── Voice ──────────────────────────────────────────────────────────────────

  Future<void> speak(String text) async {
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('[Companion] TTS error: $e');
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_enabledKey) ?? true;
    _launchAtLogin = prefs.getBool(_launchAtLoginKey) ?? false;
    final String? raw = prefs.getString(_tasksKey);
    if (raw != null && raw.isNotEmpty) {
      _tasks = CompanionTask.listFromJson(raw);
    }
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tasksKey, CompanionTask.listToJson(_tasks));
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.48);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
    } catch (e) {
      debugPrint('[Companion] TTS init error: $e');
    }
  }

  Future<void> _speakStartupGreeting() async {
    final DateTime now = DateTime.now();
    final String greeting = _timeGreeting(now.hour);
    final String msg =
        '$greeting! Welcome back. '
        'How are you doing today? '
        'I\'m here to help you stay on track. '
        'What would you like to accomplish today?';
    await speak(msg);
  }

  void _startReminderTimer() {
    _reminderTimer?.cancel();
    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkLunchReminder();
    });
  }

  bool _lunchReminderFiredToday = false;

  void _checkLunchReminder() {
    final DateTime now = DateTime.now();
    if (now.hour == 9 && now.minute == 30) {
      if (!_lunchReminderFiredToday) {
        _lunchReminderFiredToday = true;
        speak(
          'Hey! It\'s nine thirty. Time to have your lunch. '
          'Please take a break and enjoy your meal!',
        );
      }
    } else if (now.hour != 9 || now.minute != 30) {
      _lunchReminderFiredToday = false;
    }
  }

  static String _timeGreeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
