import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/product/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductReportCard extends StatefulWidget {
  final ProductModel model;

  const ProductReportCard({super.key, required this.model});

  @override
  State<ProductReportCard> createState() => _ProductReportCardState();
}

class _ProductReportCardState extends State<ProductReportCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1))]),
      child: Card(
        margin: const EdgeInsets.all(.6),
        color: Colors.white,
        elevation: 0,
        child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(_getImageUrl),
            ),
            dense: true,
            style: ListTileStyle.drawer,
            subtitle: Text("Sold quantity: ${widget.model.soldQuantity}"),
            visualDensity: VisualDensity.comfortable,
            title: Text(widget.model.productName ?? ""),
            trailing: Text(
              "+\$${HelperMethod.formatNumber(widget.model.soldQuantity!.toDouble() * widget.model.price!)}",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp),
            )),
      ),
    );
  }

  String get _getImageUrl =>
      "http://127.0.0.1:3000/products/images/${widget.model.images?.isNotEmpty ?? true ? widget.model.images![0] : "65de97241f415ab91a7d4ecf"}";
}
