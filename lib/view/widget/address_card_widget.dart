
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:flutter/material.dart';

class AddressWidget extends StatelessWidget {
  final Address model;
  final VoidCallback? onTap;
  final bool isSelected;

  const AddressWidget({
    super.key,
    required this.model,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:  Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.lightGray),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          title: _title(model.addressNickName ?? "Home"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(model.addressLine1 ?? ""),
              _text(model.addressLine2 ?? ""),
              _text(model.city ?? ""),
              _text((model.zipCode ?? "").toUpperCase())
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
