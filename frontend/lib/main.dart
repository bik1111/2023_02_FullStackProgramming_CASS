import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/models/cafe_list.dart';
import 'package:full_stack_project/features/cafe/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CafeList(),
      child: MaterialApp(
        title: 'Flutter Cafe App',
        home: HomePage(),
      ),
    );
  }
}
