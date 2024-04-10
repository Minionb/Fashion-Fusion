import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/data/product/model/product_model.dart';
import 'package:fashion_fusion/provider/product_cubit/product/product_cubit.dart';
import 'package:fashion_fusion/provider/product_cubit/product_edit/product_edit_cubit.dart';
import 'package:fashion_fusion/view/admin/view/admin_product_deatils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

class AdminProductCard extends StatefulWidget {
  final ProductModel model;
  final bool? showQuantity;
  Map<String, String>? productQueryParams;
  AdminProductCard(
      {super.key,
      required this.model,
      this.productQueryParams,
      this.showQuantity});

  @override
  State<AdminProductCard> createState() => _AdminProductCardState();
}

class _AdminProductCardState extends State<AdminProductCard> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductEditCubit, ProductEditState>(
      listener: (context, state) {
        if (state is ProductEditIsLoadingState) {
          // context.loaderOverlay.show();
        }
        if (state is ProductEditSuccessState) {
          context.loaderOverlay.hide();
          context.loaderOverlay.hide();
          HelperMethod.showToast(context,
              title: const Text("Product deleted successfully"),
              type: ToastificationType.success);
        }
        if (state is ProductEditErrorState) {
          context.loaderOverlay.hide();
          context.loaderOverlay.hide();
          HelperMethod.showToast(context,
              title: Text(state.message), type: ToastificationType.error);
        }
      },
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text("Delete Product"),
                      content: const Text(
                          "Are you sure you want to delete this product?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop("deleted");
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<ProductEditCubit>()
                                .deleteProduct(widget.model.id ?? "");
                            Navigator.of(context).pop("deleted");
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                ).then((value) {
                  if (value != null) {
                    context
                        .read<ProductCubit>()
                        .getProduct(widget.productQueryParams);
                  }
                });
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {}),
            children: [
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ]),
        key: Key(widget.model.id ?? ""),
        direction: Axis.horizontal,
        child: ListTile(
          onTap: () {
            context.pushNamedNAV(AdminProductDetailsScreen(
              model: widget.model,
            ));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_getImageUrl),
          ),
          style: ListTileStyle.drawer,
          subtitle: Text(widget.showQuantity == true
              ? "Sold quantity: ${widget.model.soldQuantity}"
              : "\$${widget.model.price ?? 0}"),
          visualDensity: VisualDensity.comfortable,
          title: Text(widget.model.productName ?? ""),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  String get _getImageUrl =>
      "http://127.0.0.1:3000/products/images/${widget.model.images?.isNotEmpty ?? true ? widget.model.images![0] : "65de97241f415ab91a7d4ecf"}";
}
