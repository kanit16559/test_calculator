

import 'package:sqflite/sqflite.dart';
import 'package:test_calculator/core/local_constants.dart';
import 'package:test_calculator/core/result/app_result.dart';
import 'package:test_calculator/datasource/product/productlist_datasource.dart';
import 'package:test_calculator/models/product/product_model.dart';

import '../database_helper.dart';

class ProductListLocal implements ProductListDataSource {

  final DatabaseHelper databaseService;

  ProductListLocal({
    required this.databaseService
  });

  @override
  Future<AppResult<List<ProductModel>>> getDataAll() async{
    try{
      Database dbClient = await databaseService.database;
      List<Map> maps = await dbClient.query(
        tableProductName,
        columns: ['id', 'name', 'image', 'price', 'date']
      );
      List<ProductModel> productList = [];
      for(int i = 0; i<maps.length; i++) {
        productList.add(ProductModel.fromJson(maps[i]));
      }

      return Success(value: productList);
    }catch(error){
      return Error(errorObject: error);
    }

  }

  @override
  Future<AppResult<List<ProductModel>>> getDataById() {
    // TODO: implement getDataById
    throw UnimplementedError();
  }

  @override
  Future<AppResult> insertData(ProductModel product) async{
    try{
      Database dbClient = await databaseService.database;
      final result = await dbClient.insert(tableProductName, product.toMap());
      return Success(value: result);
    }catch(error){
      return Error(errorObject: error);
    }
  }

  @override
  Future<AppResult> updateData(ProductModel product) async{
    try{
      Database dbClient = await databaseService.database;
      final result = await dbClient.update(tableProductName, product.toMap(), where: "id = ?", whereArgs: [product.id]);
      return Success(value: result);
    }catch(error){
      return Error(errorObject: error);
    }
  }

  @override
  Future<AppResult> deleteData(ProductModel product) async{
    try{
      Database dbClient = await databaseService.database;
      final result = await dbClient.delete(tableProductName, where: "id = ?", whereArgs: [product.id]);
      return Success(value: result);
    }catch(error){
      return Error(errorObject: error);
    }
  }

}