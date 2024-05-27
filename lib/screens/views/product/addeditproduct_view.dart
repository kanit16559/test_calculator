
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_calculator/models/product/product_model.dart';
import 'package:test_calculator/view_models/product/productlist_viewmodel.dart';

class AddEditProductView extends StatefulWidget {
  const AddEditProductView({super.key, required this.controller, this.product});

  final ProductListViewModel controller;
  final ProductModel? product;

  @override
  State<AddEditProductView> createState() => _AddEditProductViewState();
}

class _AddEditProductViewState extends State<AddEditProductView> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  late ProductListViewModel controller;
  late bool isUpdate = false;


  @override
  void initState() {
    controller = widget.controller;
    isUpdate = widget.product != null;
    if(isUpdate == true){
      setTextField();
    }
    super.initState();
  }

  setTextField(){
    _nameController.text = widget.product!.name!;
    _priceController.text = widget.product!.price!.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate == true ? "Edit Product" :"Add Product"
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            _buildTextField(
                              controller: _nameController,
                              hintText: "Name"
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Price",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            _buildTextField(
                                controller: _priceController,
                                hintText: "Price"
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60), // fromHeight use double.infinity as width and 40 is the height
                ),
                onPressed: () {
                  if(isUpdate == true){
                    controller.editProduct(
                      id: widget.product!.id!,
                      name: _nameController.text,
                      price: _priceController.text
                    ).then((value) => Navigator.pop(context));
                    return;
                  }

                  controller.addProduct(
                    name: _nameController.text,
                    price: _priceController.text
                  ).then((value) => Navigator.pop(context));
                },
                child: Text(
                  isUpdate == true ? 'Edit' :'Add',
                  style: const TextStyle(
                    fontSize: 20
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextField({
    TextEditingController? controller,
    required String hintText,
    bool isOnlyNumber = false
  }){
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      keyboardType: isOnlyNumber == true ? TextInputType.number : null,
      inputFormatters: isOnlyNumber == true ? <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ] : null,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.disabledColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        // You can add more customization to the decoration as needed
        // For example, adding icons, labels, etc.
      ),
    );
  }
}
