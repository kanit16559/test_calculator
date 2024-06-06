
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_calculator/repository/productlist_repository.dart';
import 'package:test_calculator/services/firebase_service.dart';
import 'package:test_calculator/services/local/database_helper.dart';
import 'package:test_calculator/services/notification_service.dart';
import 'package:test_calculator/view_models/calculator/calculator_viewmodel.dart';
import 'package:test_calculator/view_models/map/map_viewmodel.dart';
import 'package:test_calculator/view_models/product/productlist_viewmodel.dart';

import '../firebase_options.dart';
import '../services/local/product/productlist_service.dart';

class AppInjections {

  AppInjections._internal();

  static final AppInjections internal = AppInjections._internal();

  factory AppInjections(){
    return internal;
  }

  GetIt get getItInstance => GetIt.instance;

  Future initInjections() async {
    await _initNotificationServiceInjections();
    await _initFirebaseOptionsInjections();
    await _initDatabaseInjections();
    _initCalculatorInjections();
    _initProductListInjections();
    _initMapInjections();
  }

  Future<void> _initDatabaseInjections()async{
    getItInstance.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
    // await getItInstance.isReady<DatabaseHelper>();
  }

  Future<void> _initNotificationServiceInjections() async {
    getItInstance.registerSingleton(NotificationService());
    await getItInstance<NotificationService>().initNotification();
  }

  Future<void> _initFirebaseOptionsInjections() async {
    try{
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      getItInstance.registerSingleton(FirebaseService(notificationService: getItInstance<NotificationService>()));
      await getItInstance<FirebaseService>().getToken();
      await getItInstance<FirebaseService>().setupInteractedMessage();
    }catch(error){
      print('==== error:${error}');
    }
  }

  void _initCalculatorInjections() {
    // getItInstance.registerFactory<CalculatorViewModel>(() => CalculatorViewModel());
    getItInstance.registerSingleton(CalculatorViewModel());
  }

  void _initProductListInjections(){
    ProductListLocal productListLocal = ProductListLocal(
        databaseService: getItInstance<DatabaseHelper>()
    );
    getItInstance.registerFactory(() => ProductListRepository(productListLocal: productListLocal));
  }

  void _initMapInjections(){
    getItInstance.registerFactory(() => MapViewModel());
  }
}