import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sliver_stream/sliver_stream.dart';

void main() {
  testWidgets('SliverStream should render items from stream on demand', (
    WidgetTester tester,
  ) async {
    final List<int> items = [1, 2, 3];

    // Create a stream that emits items when requested
    final stream = Stream.fromIterable(items);

    // Build our widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverStream<int>(
                stream: stream,
                builder: (value) => ListTile(title: Text('Item $value')),
              ),
            ],
          ),
        ),
      ),
    );

    // Wait for the first item to load
    await tester.pumpAndSettle();

    // First item should be visible
    expect(find.text('Item 1'), findsOneWidget);

    // Scroll to trigger loading of more items
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Second item should now be visible
    expect(find.text('Item 2'), findsOneWidget);

    // Scroll more to see the third item
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Third item should now be visible
    expect(find.text('Item 3'), findsOneWidget);

    // All three items should be visible now
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('SliverStream should handle errors gracefully', (
    WidgetTester tester,
  ) async {
    bool errorCalled = false;

    // Create a stream that throws an error
    final stream =
        Stream<int>.error(Exception('Test error')).asBroadcastStream();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverStream<int>(
                stream: stream,
                onError: (context, error, stackTrace) {
                  errorCalled = true;
                },
                builder: (value) => ListTile(title: Text('Item $value')),
              ),
            ],
          ),
        ),
      ),
    );

    // Wait for error to be processed
    await tester.pumpAndSettle();

    // Verify error handler was called
    expect(errorCalled, true);
    expect(find.byType(ListTile), findsNothing);
  });
}
