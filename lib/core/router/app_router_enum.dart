
enum AppRouteEnum {
  homeView,
  calculatorView,
  productListView,
  addProductView,
}

extension AppRouteExtension on AppRouteEnum {
  String get name {
    switch(this){
      case AppRouteEnum.calculatorView:
        return "/calculator_view";
      case AppRouteEnum.productListView:
        return "/productlist_view";
      case AppRouteEnum.addProductView:
        return "/addproduct_view";
      default:
        return "/home_view";
    }
  }
}