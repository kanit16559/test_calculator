

import '../../core/result/app_result.dart';
import '../../models/product/product_model.dart';

abstract class ProductListDataSource {
  Future<AppResult<List<ProductModel>>> getDataAll();
  Future<AppResult<List<ProductModel>>> getDataById();
  Future<AppResult> insertData(ProductModel product);
  Future<AppResult> updateData(ProductModel product);
  Future<AppResult> deleteData(ProductModel product);
}