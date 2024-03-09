import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/data/product/model/product_model.dart';
import 'package:fashion_fusion/provider/product_cubit/product_edit/product_edit_cubit.dart';
import 'package:fashion_fusion/view/admin/view/admin_product_deatils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AdminProductCard extends StatefulWidget {
  final ProductModel model;

  const AdminProductCard({super.key, required this.model});

  @override
  State<AdminProductCard> createState() => _AdminProductCardState();
}

class _AdminProductCardState extends State<AdminProductCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          context.read<ProductEditCubit>().deleteProduct(widget.model.id ?? "");
        }),
        children: [
          SlidableAction(
            onPressed: (context) {
              context
                  .read<ProductEditCubit>()
                  .deleteProduct(widget.model.id ?? "");
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
        subtitle: Text("\$${widget.model.price ?? 0}"),
        visualDensity: VisualDensity.comfortable,
        title: Text(widget.model.productName ?? ""),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }

  String get _getImageUrl =>
      "http://127.0.0.1:3000/products/images/${widget.model.images?.isNotEmpty ?? true ? widget.model.images![0] : "65de97241f415ab91a7d4ecf"}";
}
