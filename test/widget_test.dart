// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_app/home_page.dart';
import 'package:storybook_app/main.dart';

void main() {
  testWidgets('HomePage should display correctly', (WidgetTester tester) async {
    // ✅ Build the app
    await tester.pumpWidget(MyApp());

    // ✅ ตรวจสอบว่า `HomePage` ถูกแสดงหรือไม่
    expect(find.byType(HomePage), findsOneWidget);

    // ✅ ตรวจสอบว่ามีปุ่มค้นหา
    expect(find.byIcon(Icons.search), findsOneWidget);

    // ✅ ตรวจสอบว่ามีปุ่มเล่นเกม (Icon: videogame_asset)
    expect(find.byIcon(Icons.videogame_asset), findsOneWidget);

    // ✅ ตรวจสอบว่ามีหนังสืออยู่ใน Grid หรือไม่
    expect(find.byType(GridView), findsOneWidget);
  });
}
