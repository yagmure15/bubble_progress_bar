import 'package:bubble_progress_bar/bubble_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BubbleProgressBar renders correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BubbleProgressBar(
            value: 0.5,
            height: 30,
            bubbleDensity: 0.8,
            minBubbleDiameter: 5,
            maxBubbleDiameter: 15,
            gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
          ),
        ),
      ),
    );

    expect(find.byType(BubbleProgressBar), findsOneWidget);
    expect(find.byType(CustomPaint), findsOneWidget);
  });
}
