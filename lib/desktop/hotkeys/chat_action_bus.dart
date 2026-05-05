import 'dart:async';

enum ChatAction {
  newTopic,
  toggleLeftPanelAssistants,
  toggleLeftPanelTopics,
  focusInput,
  switchModel,
}

class ChatActionBus {
  ChatActionBus._();
  static final ChatActionBus instance = ChatActionBus._();

  final _controller = StreamController<ChatAction>.broadcast();
  final _promptController = StreamController<String>.broadcast();
  Stream<ChatAction> get stream => _controller.stream;
  Stream<String> get promptStream => _promptController.stream;
  void fire(ChatAction action) => _controller.add(action);
  void sendPrompt(String prompt) {
    final trimmed = prompt.trim();
    if (trimmed.isEmpty) return;
    _promptController.add(trimmed);
  }

  void dispose() {
    _controller.close();
    _promptController.close();
  }
}
