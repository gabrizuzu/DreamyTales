import 'package:dreamy_tales/pages/app_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamy_tales/widgets/myDrawer.dart';

void main() {
  testWidgets('MyDrawer should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyDrawer(
            currentCategory: AppCategory.home,
            onCategorySelected: (category) {},
            onLogout: () {},
            onExit: () {},
          ),
        ),
      ),
    );

    // Verify that the MyDrawer is built without errors
    expect(find.byType(MyDrawer), findsOneWidget);
  });

  testWidgets('MyDrawer should have the correct number of InkWell', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyDrawer(
            currentCategory: AppCategory.home,
            onCategorySelected: (category) {},
            onLogout: () {},
            onExit: () {},
          ),
        ),
      ),
    );

    // Verify that there are 10 InkWell in the drawer, 1 for Text and 1 for the Button (Home, My Stories, Analytics, Settings, EXIT)
    expect(find.byType(InkWell), findsNWidgets(10));
  });

  testWidgets('MyDrawer should highlight the selected category', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyDrawer(
            currentCategory: AppCategory.myStories,
            onCategorySelected: (category) {},
            onLogout: () {},
            onExit: () {},
          ),
        ),
      ),
    );

    // Verify that the My Stories button is highlighted and find 2 instances of InkWell (Button and Text)
    expect(find.widgetWithText(InkWell, 'My Stories'), findsNWidgets(2));
  });

}
