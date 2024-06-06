import 'package:flutter/material.dart';
import 'package:test_calculator/repository/productlist_repository.dart';
import 'package:test_calculator/services/firebase_service.dart';
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

class _ProductListViewState extends State<ProductListView> with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();

  late ProductListViewModel controller;

  late FirebaseService firebaseService;

  @override
  void initState() {
    firebaseService = AppInjections.internal.getItInstance<FirebaseService>();
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
                "controller": controller,
                "globalKeyAnimated": _animatedListKey
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
        // widget = ListView.builder(
        //   itemCount: state.productList.length,
        //   itemBuilder: (context, index){
        //     ProductModel product = state.productList[index];
        //     return ProductWidget(
        //       product: product,
        //       controller: controller,
        //       // animationSeconds: index+1,
        //     );
        //   }
        // );

        widget = AnimatedList(
          key: _animatedListKey,
          initialItemCount: state.productList.length,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            ProductModel product = state.productList[index];
            return SlideTransition(
              key: UniqueKey(),
              position: Tween<Offset>(
                begin: const Offset(1.5, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticOut,
                )
              ),
              child: ProductWidget(
                product: product,
                controller: controller,
                globalKeyAnimated: _animatedListKey, index: index,
                // animationSeconds: index+1,
              ),
            );
          },
        );
      default:
        widget = Container();
    }

    return widget;
  }
}
