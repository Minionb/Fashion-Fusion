import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/provider/product_cubit/product/product_cubit.dart';
import 'package:fashion_fusion/view/admin/view/admin_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AdminCategoryCard extends StatefulWidget {
  final String model;

  const AdminCategoryCard({super.key, required this.model});

  @override
  State<AdminCategoryCard> createState() => _AdminCategoryCardState();
}

class _AdminCategoryCardState extends State<AdminCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            onPressed: (context) {},
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
      key: Key(widget.model),
      direction: Axis.horizontal,
      child: ListTile(
        onTap: () {
          context.pushNamedNAV(BlocProvider(
            create: (context) => sl<ProductCubit>()..getProduct(),
            child: const AdminProductScreen(),
          ));
        },
        style: ListTileStyle.drawer,
        visualDensity: VisualDensity.comfortable,
        title: Text(widget.model),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }
}
