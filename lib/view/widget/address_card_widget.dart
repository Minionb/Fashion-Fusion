
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:flutter/material.dart';

class AddressWidget extends StatefulWidget {
  final Address model;
  final bool isSelected;
  final VoidCallback? onTap;

  const AddressWidget({
    super.key,
    required this.model,
    this.isSelected = false,
    this.onTap,
  });

  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  widget.isSelected ? AppColors.primary : AppColors.lightGray),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.only(bottom: 16.0), // Add margin
        child: ListTile(
          title: _title(widget.model.addressNickName ?? "Home"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(widget.model.addressLine1 ?? ""),
              _text(widget.model.addressLine2 ?? ""),
              _text(widget.model.city ?? ""),
              _text((widget.model.zipCode ?? "").toUpperCase())
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  Widget _text(String addressLine) {
    return Text(
      addressLine,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
    );
  }
}
