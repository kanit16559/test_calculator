import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_calculator/models/product/product_model.dart';
import 'package:test_calculator/repository/productlist_repository.dart';

import '../../core/dispose.dart';

enum AppProductListStatus { initial, loading, success, failure }

class ProductListViewModel extends Dispose {

  ProductListRepository productListRepository;

  ProductListViewModel({
    required this.productListRepository
  }) {
    initMyState();
  }

  final BehaviorSubject<ProductListState> _productListState = BehaviorSubject<ProductListState>();

  BehaviorSubject<ProductListState> get productListState => _productListState;

  void initMyState(){
    _productListState.add(ProductListState(
      productList: []
    ));
  }

  @override
  void dispose() {
    _productListState.close();
  }

  _updateProductListState(ProductListState state){
    _productListState.sink.add(state);
  }

  Future<void> addProduct({
    required String name,
    required String price,
  }) async {
    ProductModel product = ProductModel(
      name: name,
      price: double.parse(price)
    );
    final appResult = await productListRepository.insertData(product);
    getDataAll();
  }

  Future<void> editProduct({
    required int id,
    required String name,
    required String price,
  }) async {
    ProductModel product = ProductModel(
      id: id,
      name: name,
      price: double.parse(price)
    );
    final appResult = await productListRepository.updateData(product);
    getDataAll();
  }

  Future<void> getDataAll() async {
    _productListState.sink.add(
      _productListState.value.copyWith(
        status: AppProductListStatus.loading,
      )
    );

    final appResult = await productListRepository.getDataAll();
    appResult.whenWithResult((result) {
      _productListState.sink.add(
        _productListState.value.copyWith(
          status: AppProductListStatus.success,
          productList: result.value
        )
      );
    }, (error) {
      _productListState.sink.add(
        _productListState.value.copyWith(
          status: AppProductListStatus.failure,
          productList: []
        )
      );
    });
  }

  Future<void> deleteData(ProductModel product)async{
    final appResult = await productListRepository.deleteData(product);
    getDataAll();
  }

}

class ProductListState {
  AppProductListStatus status;
  List<ProductModel> productList;

  ProductListState({
    this.status = AppProductListStatus.initial,
    required this.productList
  });

  ProductListState copyWith({
    AppProductListStatus? status,
    List<ProductModel>? productList
  }){
    return ProductListState(
      status: status ?? this.status,
      productList: productList ?? this.productList
    );
  }
}