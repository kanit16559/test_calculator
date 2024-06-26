import 'package:flutter/material.dart';
import 'package:test_calculator/services/notification_service.dart';

import '../../../core/app_injection.dart';
import '../../../core/router/app_router_enum.dart';
import '../../../services/firebase_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    AppInjections.internal.getItInstance<FirebaseService>().requestPermission();
    super.initState();
  }


  final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home"
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: style,
              onPressed: (){
                Navigator.pushNamed(
                  context,
                  AppRouteEnum.calculatorView.name,
                );
              },
              child: const Text('Calculator'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: style,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouteEnum.productListView.name,
                );
              },
              child: const Text('Products'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: style,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouteEnum.mapView.name,
                );
              },
              child: const Text('Map'),
            ),
          ],
        ),
      ),
    );
  }
}
