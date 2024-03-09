import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/widgets/custom_text_field.dart';

class InventoryCard extends StatefulWidget {
  final Function(String) onSizeChanged;
  final Function(String) onQuantityChanged;

  const InventoryCard({
    super.key,
    required this.onSizeChanged,
    required this.onQuantityChanged,
  });

  @override
  _InventoryCardState createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  TextEditingController sizeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    sizeController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.bg,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CustomTextField(
              label: "Size",
              hint: "ex: XL",
              ctrl: sizeController,
              onChanged: (size) {
                setState(() {
                  widget.onSizeChanged(size);
                });
              },
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: "Quantity",
              hint: "ex: 34",
              ctrl: quantityController,
              onChanged: (quantity) {
                setState(() {
                  widget.onQuantityChanged(quantity);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
