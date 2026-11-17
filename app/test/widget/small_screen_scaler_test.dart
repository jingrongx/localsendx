import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/widget/small_screen_scaler.dart';

void main() {
  Future<Size> pumpScaler(
    WidgetTester tester, {
    required Size physicalSize,
    required double devicePixelRatio,
    Widget? home,
  }) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = devicePixelRatio;
    addTearDown(tester.view.reset);

    Size? virtualSize;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => SmallScreenScaler(child: child!),
        home: Builder(
          builder: (context) {
            virtualSize = MediaQuery.sizeOf(context);
            return home ?? const Scaffold(body: SizedBox());
          },
        ),
      ),
    );
    return virtualSize!;
  }

  testWidgets('tiny viewport renders on a virtual canvas with a 360 short side', (tester) async {
    final virtualSize = await pumpScaler(tester, physicalSize: const Size(308, 240), devicePixelRatio: 1.0);

    expect(virtualSize.width, closeTo(308 * 360 / 240, 0.01));
    expect(virtualSize.height, closeTo(360, 0.01));
  });

  testWidgets('normal viewport is passed through unchanged', (tester) async {
    final virtualSize = await pumpScaler(tester, physicalSize: const Size(800, 600), devicePixelRatio: 1.0);

    expect(virtualSize.width, 800);
    expect(virtualSize.height, 600);
  });

  testWidgets('content wider than the real viewport is rendered and stays tappable', (tester) async {
    var tapped = false;
    await pumpScaler(
      tester,
      physicalSize: const Size(308, 240),
      devicePixelRatio: 1.0,
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(onPressed: () {}, child: const Text('Send files')),
              const SizedBox(width: 10),
              OutlinedButton(onPressed: () => tapped = true, child: const Text('Receive here')),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Receive here'));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
