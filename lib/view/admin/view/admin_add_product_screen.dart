import 'dart:io';
import 'package:chips_choice/chips_choice.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/widgets/custom_button.dart';
import 'package:fashion_fusion/data/product/model/upload_product_model.dart';
import 'package:fashion_fusion/provider/product_cubit/product_edit/product_edit_cubit.dart';
import 'package:fashion_fusion/view/admin/widget/inventory_card.dart';
import 'package:fashion_fusion/view/admin/widget/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AdminAddProductScreen extends StatefulWidget {
  const AdminAddProductScreen({super.key});

  @override
  _AdminAddProductScreenState createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? image;
  List<String> tags = [];
  List<InventoryCard> inv = [];
  List<String> categories = [];
  List<String> options = [
    'casual',
    'formal',
    'none',
    'skirt',
    'leggings',
    'sporty',
    'cozy',
    'office wear'
  ];
  List<String> sizes = [];
  List<String> quantities = [];
  List<Inventory> listOfInvontry = [];
  @override
  Widget build(BuildContext context) {
    return HelperMethod.loader(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Product"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: BlocListener<ProductEditCubit, ProductEditState>(
                listener: (context, state) {
                  if (state is ProductEditIsLoadingState) {
                    context.loaderOverlay.show();
                  }
                  if (state is ProductEditSuccessState) {
                    context.loaderOverlay.hide();
                    HelperMethod.showToast(context,
                        title: const Text("Product added successfully"),
                        type: ToastificationType.success);
                  }
                  if (state is ProductEditErrorState) {
                    context.loaderOverlay.hide();
                    HelperMethod.showToast(context,
                        title: Text(state.message),
                        type: ToastificationType.error);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    image == null
                        ? GestureDetector(
                            onTap: () async {
                              await _selectImage(context);
                            },
                            child: CircleAvatar(
                              minRadius: 50.sp,
                              backgroundColor: AppColors.primary,
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ProfileWidget(
                            imagePath: image?.path ?? "",
                            isEdit: true,
                            fromFile: true,
                            onClicked: () async {
                              await _selectImage(context);
                            },
                          ),
                    TextFormField(
                      controller: productNameController,
                      decoration:
                          const InputDecoration(labelText: 'Product Name'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: productDescriptionController,
                      decoration: const InputDecoration(
                          labelText: 'Product Description'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a product description';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a price';
                        }
                        // You can add additional validation here if needed
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a quantity';
                        }
                        // You can add additional validation here if needed
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _selectTagsChip(),
                    16.verticalSpace,
                    _selectCategoriesChip(),
                    16.verticalSpace,
                    CustomButton(
                        label: "Save",
                        onPressed: () {
                          // for (var i = 0; i < sizes.length; i++) {
                          //   if (i < quantities.length) {
                          //     listOfInvontry.add(Inventory(
                          //         size: sizes[i],
                          //         quantity: int.parse(quantities[i])));
                          //   }
                          // }

                          if (_formKey.currentState!.validate()) {
                            final model = UploadProductModel(
                                productName: productNameController.text,
                                category: categories
                                    .map((e) => e)
                                    .toString()
                                    .replaceAll(")", "")
                                    .replaceAll("(", ""),
                                productDescription:
                                    productDescriptionController.text,
                                price: double.parse(priceController.text),
                                tags: tags
                                    .map((e) => "#$e")
                                    .toString()
                                    .replaceAll(")", "")
                                    .replaceAll("(", ""),
                                soldQuantity:
                                    int.parse(quantityController.text),
                                image: image,
                                inventory: []);
                            context.read<ProductEditCubit>().addProduct(model);
                          }
                        },
                        bg: AppColors.primary),
                    50.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _selectTagsChip() {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select tags",
            style: TextStyle(fontSize: 14.sp),
          ),
          ChipsChoice<String>.multiple(
            wrapped: true,
            value: tags,
            onChanged: (val) => setState(() => tags = val),
            choiceItems: C2Choice.listFrom<String, String>(
              source: options,
              value: (i, v) => v,
              label: (i, v) => v,
            ),
          ),
        ],
      ),
    );
  }

  Container _selectCategoriesChip() {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Categories",
            style: TextStyle(fontSize: 14.sp),
          ),
          ChipsChoice<String>.multiple(
            wrapped: true,
            value: categories.isNotEmpty ? categories : [],
            onChanged: (val) => setState(() => categories = val),
            choiceItems: C2Choice.listFrom<String, String>(
              source: [
                "Tops",
                "Bottoms",
                "Dresses",
                "Hoodies & Sweats",
                "Accessories",
              ],
              value: (i, v) => v,
              label: (i, v) => v,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectImage(BuildContext context) async {
    return await openImageProfile(context).then((value) async {
      value?.first.file.then((value) async {
        value != null ? image = value : image;
        setState(() {});
        if ((await value?.length())! >= 512000) {
          // Constants.showToast(
          //     msg: "File must not be over 512 KB",
          //     color: Colors.red.withOpacity(.9));
        } else {
          value != null ? image = value : image;
          setState(() {});
        }
      });
    });
  }

  Future<List<AssetEntity>?> openImageProfile(BuildContext context) async {
    await [
      Permission.photos,
      Permission.storage,
    ].request();

    return AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
        ));
  }
}
