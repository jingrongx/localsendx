import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/util/navigation_compat.dart';
import 'package:refena_flutter/addons.dart';
import 'package:refena_flutter/refena_flutter.dart';

class _TargetPage extends StatelessWidget {
  const _TargetPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('target page'));
  }
}

class _PlainPage extends StatelessWidget {
  const _PlainPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('plain page'));
  }
}

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      RefenaScope(
        child: Builder(
          builder: (context) {
            return MaterialApp(
              navigatorKey: context.read(navigationProvider).key,
              home: const Scaffold(body: Text('root page')),
            );
          },
        ),
      ),
    );
  }

  Future<void> pushNamed(WidgetTester tester, String name) async {
    unawaited(
      tester
          .state<NavigatorState>(find.byType(Navigator))
          .push(
            MaterialPageRoute(
              builder: (_) => name == '$_TargetPage' ? const _TargetPage() : const _PlainPage(),
              settings: RouteSettings(name: name),
            ),
          ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> popUntil(WidgetTester tester, {required bool targetOnStack}) async {
    tester
        .element(find.byType(Navigator))
        .global
        .dispatch(targetOnStack ? NavigateActionCompat.popUntil<_TargetPage>() : NavigateActionCompat.popUntil<_PlainPage>());
    await tester.pumpAndSettle();
  }

  testWidgets('popUntil keeps the root route when the target page is not on the stack', (tester) async {
    await pumpApp(tester);
    await pushNamed(tester, 'plainA');
    await pushNamed(tester, 'plainB');

    // No route named '$_TargetPage' exists: the action must fall back to the
    // root instead of popping everything (which leaves a black screen).
    await popUntil(tester, targetOnStack: false);

    expect(tester.takeException(), isNull);
    expect(find.text('root page'), findsOneWidget);
    expect(find.text('plain page'), findsNothing);
  });

  testWidgets('popUntil stops at the target page when it is on the stack', (tester) async {
    await pumpApp(tester);
    await pushNamed(tester, '$_TargetPage');
    await pushNamed(tester, 'plainB');

    await popUntil(tester, targetOnStack: true);

    expect(tester.takeException(), isNull);
    expect(find.text('target page'), findsOneWidget);
    expect(find.text('plain page'), findsNothing);
    expect(find.text('root page'), findsNothing);
  });
}
