
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:flutter/material.dart';

class PaymentWidget extends StatefulWidget {
  final Payments model;
  final bool isSelected;
  final VoidCallback? onTap;

  const PaymentWidget({
    Key? key,
    required this.model,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  bool tapped = false;

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
        margin: const EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          title: _name(),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_card(), _exp()],
          ),
        ),
      ),
    );
  }

  Widget _name() {
    return Expanded(
      child: Text(
        widget.model.name ?? '',
        maxLines: 2,
        textAlign: TextAlign.left,
        overflow: TextOverflow.fade,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Text _exp() {
    return Text(
      widget.model.expirationDate ?? '',
      style: TextStyle(color: AppColors.textGray),
    );
  }

  Text _card() {
    return Text(
      widget.model.cardNumber ?? '',
      style: TextStyle(color: AppColors.textGray),
    );
  }
}
