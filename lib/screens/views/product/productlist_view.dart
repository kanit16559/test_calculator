import 'package:flutter/material.dart';
import 'package:test_calculator/repository/productlist_repository.dart';
import 'package:test_calculator/view_models/product/productlist_viewmodel.dart';

import '../../../core/app_injection.dart';
import '../../../core/router/app_router_enum.dart';
import '../../../models/product/product_model.dart';
import '../../widgets/product/product_widget.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {

  late ProductListViewModel controller;

  @override
  void initState() {
    controller = ProductListViewModel(productListRepository: AppInjections.internal.getItInstance<ProductListRepository>());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getDataAll();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product List"
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRouteEnum.addProductView.name, arguments: {
                "controller": controller
              });
            },
          )
        ],
      ),
      body: StreamBuilder<ProductListState>(
        stream: controller.productListState,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(child: Text("Error"));
          }

          if(snapshot.hasData){
            return _buildBody(context, snapshot);
          }

          return Container();
        }
      ),
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<ProductListState> snapshot){
    Widget widget = Container();
    ProductListState state = snapshot.data!;
    switch(state.status){
      case AppProductListStatus.initial:
      case AppProductListStatus.loading:
        widget = const Center(child: CircularProgressIndicator());
      case AppProductListStatus.failure:
        widget = const Center(child: Text("Failure !!!"));
      case AppProductListStatus.success:
        widget = ListView.builder(
          itemCount: state.productList.length,
          itemBuilder: (context, index){
            ProductModel product = state.productList[index];
            return ProductWidget(product: product, controller: controller);
          }
        );
      default:
        widget = Container();
    }

    return widget;
  }
}
