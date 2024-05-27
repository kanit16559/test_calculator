import 'package:flutter/material.dart';
import 'package:test_calculator/screens/views/calculator/calculator_view.dart';
import 'package:test_calculator/screens/views/home/home_view.dart';
import 'package:test_calculator/view_models/calculator/calculator_viewmodel.dart';

import 'core/app_injection.dart';
import 'core/router/router.dart';

void main() {
  AppInjections.internal.initInjections();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      // initialRoute: "/home_view",
      home: const HomeView()
    );
  }
}
