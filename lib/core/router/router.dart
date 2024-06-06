import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_calculator/screens/views/calculator/calculator_view.dart';
import 'package:test_calculator/screens/views/home/home_view.dart';
import 'package:test_calculator/screens/views/map/map_view.dart';
import 'package:test_calculator/screens/views/product/addeditproduct_view.dart';
import 'package:test_calculator/screens/views/product/productlist_view.dart';
import 'package:test_calculator/view_models/product/productlist_viewmodel.dart';


class AppRouter {
  static String currentRoute = "/";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentRoute = settings.name ?? "/";
    switch(settings.name){
      case '/home_view':
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => const HomeView(),
        );
      case '/calculator_view':
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) {
            return const CalculatorView();
          },
        );
      case '/productlist_view':
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) {
            return const ProductListView();
          },
        );
      case '/addproduct_view':
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) {
            final argument =  settings.arguments as Map;
            return AddEditProductView(
              controller: argument["controller"],
              product: argument["product"],
              globalKeyAnimated: argument["globalKeyAnimated"],
            );
          },
        );
      case '/map_view':
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) {
            // final argument =  settings.arguments as Map;
            return MapView();
          },
        );
      default:
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}