// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:yuksalish_mobile/main.dart';
//
// void main() {
//   testWidgets('YuksalishApp smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());
//
//     // Verify that the app builds and shows either loading or login screen
//     expect(find.byType(MyApp), findsOneWidget);
//
//     // Wait for any animations to complete
//     await tester.pumpAndSettle();
//
//     // Verify that either the loading screen or login screen is shown
//     final hasLoadingOrLogin = find.text('YUKSALISH GROUP').evaluate().isNotEmpty ||
//         find.byType(Scaffold).evaluate().isNotEmpty;
//
//     expect(hasLoadingOrLogin, isTrue);
//   });
// }
