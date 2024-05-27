
import 'package:test_calculator/core/result/app_result.dart';
import 'package:test_calculator/datasource/product/productlist_datasource.dart';
import 'package:test_calculator/models/product/product_model.dart';

import '../services/local/product/productlist_service.dart';

class ProductListRepository implements ProductListDataSource {
  ProductListLocal productListLocal;

  ProductListRepository({
    required this.productListLocal
  });

  @override
  Future<AppResult<List<ProductModel>>> getDataAll() {
    return productListLocal.getDataAll();
  }

  @override
  Future<AppResult<List<ProductModel>>> getDataById() {
    return productListLocal.getDataById();
  }

  @override
  Future<AppResult> insertData(ProductModel product) {
    return productListLocal.insertData(product);
  }

  @override
  Future<AppResult> updateData(ProductModel product) {
    return productListLocal.updateData(product);
  }

  @override
  Future<AppResult> deleteData(ProductModel product) {
    return productListLocal.deleteData(product);
  }

}