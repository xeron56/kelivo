import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

bool hasGoRouter(BuildContext context) {
  try {
    GoRouter.of(context);
    return true;
  } catch (_) {
    return false;
  }
}

void popRouterOrNavigator(BuildContext context) {
  if (hasGoRouter(context)) {
    context.pop();
    return;
  }

  final navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop();
  }
}
