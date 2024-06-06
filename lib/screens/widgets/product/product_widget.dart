import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_calculator/view_models/product/productlist_viewmodel.dart';

import '../../../core/router/app_router_enum.dart';
import '../../../models/product/product_model.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.product, required this.controller, required this.index, required this.globalKeyAnimated});

  final ProductModel product;
  final ProductListViewModel controller;
  final int index;
  final GlobalKey<AnimatedListState> globalKeyAnimated;


  @override
  Widget build(BuildContext context) {
    String imageJson = "Here, I put the BASE64 string";
    Uint8List image = Uint8List(1);
    // Uint8List image = base64Decode(imageJson);
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          Builder(
            builder: (context) {
              return GestureDetector(
                onTap: (){
                  Slidable.of(context)!.close().then((value) {
                    controller.deleteData(product).then((value) {
                      globalKeyAnimated.currentState?.removeItem(index, (context, animation) {
                        return SlideTransition(
                          key: UniqueKey(),
                          position: Tween<Offset>(
                            begin: const Offset(1.5, 0.0),
                            end: Offset.zero,
                          ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCirc,
                              )
                          ),
                          child: ProductWidget(
                            product: product,
                            controller: controller,
                            globalKeyAnimated: globalKeyAnimated,
                            index: index,
                            // animationSeconds: index+1,
                          ),
                        );
                      }, duration: Duration(milliseconds: 800));
                    });
                  });


                  // controller.deleteData(product);
                },
                child: Container(
                  height: double.infinity,
                  width: 100,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        blurRadius: 10,
                        spreadRadius: 3,
                        offset: const Offset(3, 4)
                      )
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          )
        ],
      ),
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200]!,
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(3, 4))
          ],
        ),
        child: Row(
          children: [
            Image.memory(
              image,
              height: 100,
              width: 100,
              errorBuilder: (context, object, stackTrace){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(13),
                    ),
                    height: 100,
                    width: 100,
                  ),
                );
              },

            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name ?? "",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey[500],
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouteEnum.addProductView.name, arguments: {
                              "controller": controller,
                              "product": product
                            });
                          },
                        )
                      ],
                    ),
                    Text(
                      "\$ ${product.price?.toString() ?? ""}",
                      style: const TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "date: ${product.date ?? ""}",
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          "${product.id ?? "0"}"
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
