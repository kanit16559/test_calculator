
import 'package:get_it/get_it.dart';
import 'package:test_calculator/repository/productlist_repository.dart';
import 'package:test_calculator/services/local/database_helper.dart';
import 'package:test_calculator/view_models/calculator/calculator_viewmodel.dart';
import 'package:test_calculator/view_models/product/productlist_viewmodel.dart';

import '../services/local/product/productlist_service.dart';

class AppInjections {

  AppInjections._internal();

  static final AppInjections internal = AppInjections._internal();

  factory AppInjections(){
    return internal;
  }

  GetIt get getItInstance => GetIt.instance;

  void initInjections() async {
    await _initDatabaseInjections();
    _initCalculatorInjections();
    _initProductListInjections();
  }

  Future<void> _initDatabaseInjections()async{
    getItInstance.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
    // await getItInstance.isReady<DatabaseHelper>();
  }

  void _initCalculatorInjections() {
    getItInstance.registerFactory<CalculatorViewModel>(() => CalculatorViewModel());
  }

  void _initProductListInjections(){
    ProductListLocal productListLocal = ProductListLocal(
      databaseService: getItInstance<DatabaseHelper>()
    );
    // ProductListRepository productListRepository = ProductListRepository(
    //   productListLocal: productListLocal
    // );
    getItInstance.registerSingleton(ProductListRepository(productListLocal: productListLocal));
    // getItInstance.registerSingleton(ProductListViewModel(productListRepository: productListRepository));
  }

}