import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/models/cafe_list.dart';
import 'package:full_stack_project/features/cafe/models/user.dart';
import 'package:full_stack_project/features/cafe/pages/auth/registration_page.dart';
import 'package:full_stack_project/provider/auth_provider.dart'; // Import AuthProvider
import 'package:provider/provider.dart';

class AuthRepository {
  static void initialize({required String appKey}) {
    // Your initialization logic here
    print('AuthRepository initialized with appKey: $appKey');
  }
}

void main() {
  AuthRepository.initialize(appKey: 'a569c8095dc7fcdbab6ed2481d3d0220');
  User currentUser = User(userId: 1); // Replace this with your actual user data
  runApp(
    MyAppConfigurator(currentUser: currentUser).configureApp(),
  );
}

class Example extends ChangeNotifier {
  // Your state management logic goes here
}

class MyAppConfigurator {
  final User? currentUser;

  MyAppConfigurator({required this.currentUser});

  Widget configureApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Example()),
        ChangeNotifierProvider.value(value: CafeList()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Add AuthProvider
        Provider.value(value: currentUser),
      ],
      child: MyApp(currentUser: currentUser),
    );
  }
}

class MyApp extends StatelessWidget {
  final User? currentUser;

  MyApp({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegistrationPage(),
    );
  }
}
