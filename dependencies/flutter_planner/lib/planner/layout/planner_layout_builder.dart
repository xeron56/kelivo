import 'package:flutter/material.dart';
import 'package:flutter_planner/planner/planner.dart';

enum PlannerSize { small, medium, large }

typedef PlannerWidgetBuilder = Widget Function(PlannerSize currentSize);

class PlannerLayoutBuilder extends StatelessWidget {
  const PlannerLayoutBuilder({
    Key? key,
    required this.activitiesHeader,
    required this.tasksHeader,
    required this.calendar,
    required this.activities,
    required this.tasks,
    required this.tabs,
    required this.fab,
  }) : super(key: key);

  final PlannerWidgetBuilder activitiesHeader;
  final PlannerWidgetBuilder tasksHeader;
  final PlannerWidgetBuilder calendar;
  final PlannerWidgetBuilder activities;
  final PlannerWidgetBuilder tasks;
  final PlannerWidgetBuilder tabs;
  final PlannerWidgetBuilder fab;

  Widget _panel({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }

  Widget _mobileScaffold(BuildContext context, PlannerSize currentSize) {
    final isCompact = currentSize == PlannerSize.small;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isCompact ? 14 : 18,
            16,
            isCompact ? 14 : 18,
            18,
          ),
          child: Column(
            children: [
              calendar(currentSize),
              const SizedBox(height: 18),
              Expanded(
                child: _panel(
                  context: context,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                  child: tabs(currentSize),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: fab(currentSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (width <= PlannerBreakpoints.small) {
            const currentSize = PlannerSize.small;
            return _mobileScaffold(context, currentSize);
          } else if (width <= PlannerBreakpoints.medium) {
            const currentSize = PlannerSize.medium;
            return _mobileScaffold(context, currentSize);
          }
          const currentSize = PlannerSize.large;
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1480),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: Column(
                              children: [
                                calendar(currentSize),
                                const SizedBox(height: 22),
                                Expanded(
                                  child: _panel(
                                    context: context,
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      20,
                                      20,
                                      8,
                                    ),
                                    child: Column(
                                      children: [
                                        tasksHeader(currentSize),
                                        const SizedBox(height: 16),
                                        const Divider(height: 1),
                                        const SizedBox(height: 8),
                                        Expanded(child: tasks(currentSize)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          flex: 2,
                          child: _panel(
                            context: context,
                            padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                            child: Column(
                              children: [
                                activitiesHeader(currentSize),
                                const SizedBox(height: 18),
                                const Divider(height: 1),
                                const SizedBox(height: 6),
                                Expanded(child: activities(currentSize)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
