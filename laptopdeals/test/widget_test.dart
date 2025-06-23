import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopdeals/main.dart';
import 'package:laptopdeals/screens/login.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:laptopdeals/provider/authprovider.dart';
import 'package:laptopdeals/provider/savedealprovider.dart';
import 'package:laptopdeals/models/laptop.dart';

Future<void> main() async {
  final mockUser = MockUser(
    isAnonymous: false,
    email: 'test@test.com',
    uid: '1234567890',
  );
  final mockAuth = MockFirebaseAuth(mockUser: mockUser);
  testWidgets('App shows title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)],
        child: const LaptopApp(),
      ),
    );
    await tester.pumpAndSettle(); // wait for all widgets to build

    expect(find.text('Laptop Deals'), findsOneWidget);
  });

  testWidgets('Login page shows required elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)],
        child: MaterialApp(home: AppShell(body: LoginPage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Log In To Laptop Deal'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Enter Your Email'), findsOneWidget);
    expect(
      find.widgetWithText(TextField, 'Enter Your Password'),
      findsOneWidget,
    );
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Test wishlist adding and removing', (WidgetTester tester) async {
    // Create a test laptop
    final testLaptop = Laptop(
      id: '1',
      name: 'Test Laptop',
      price: 1000,
      imagePath: 'test_image.jpg',
      description: 'Test Description',
      cpu: 'Intel i7',
      gpu: 'NVIDIA RTX 3060',
      ram: '16GB',
      screenSize: '15.6"',
      refreshRate: '144Hz',
    );

    // Create a container to access providers
    final container = ProviderContainer(
      overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)],
    );

    // Build the app
    await tester.pumpWidget(
      // access the provider wihtout scope ?
      UncontrolledProviderScope(container: container, child: const LaptopApp()),
    );
    await tester.pumpAndSettle();

    // Test adding to wishlist
    container.read(saveDealProvider.notifier).saveDeal(testLaptop);
    await tester.pumpAndSettle();

    // Verify the laptop was added
    final savedDeals = container.read(saveDealProvider);
    expect(savedDeals.contains(testLaptop), true);

    // Test removing from wishlist
    container.read(saveDealProvider.notifier).removeDeal(testLaptop);
    await tester.pumpAndSettle();

    // Verify the laptop was removed
    final updatedSavedDeals = container.read(saveDealProvider);
    expect(updatedSavedDeals.contains(testLaptop), false);
  });
}
