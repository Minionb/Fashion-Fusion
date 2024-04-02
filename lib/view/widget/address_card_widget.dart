import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddressWidget extends StatelessWidget {
  final Address model;
  final VoidCallback? onTap;
  final Function(Address)? onDelete;
  final bool isSelected;
  final bool readOnly;

  const AddressWidget({
    super.key,
    required this.model,
    this.isSelected = false,
    this.readOnly = true,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.lightGray),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _title(model.addressNickName ?? "Home"),
            if (!readOnly) _buildDeleteIconButton(context)
          ]),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createKeyValRow('Address line 1', model.addressLine1 ?? ""),
              _createKeyValRow('Address line 2', model.addressLine2 ?? ""),
              _createKeyValRow('City', model.city ?? ""),
              _createKeyValRow('Zip Code', (model.zipCode ?? "").toUpperCase()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteIconButton(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDeleteDialog(context);
      },
    )]);
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete!(model);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Row _createKeyValRow(String label, String val) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _label(label),
        ),
        Expanded(
          flex: 2,
          child: _text(val),
        ),
      ],
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

  Widget _label(String text) {
    var formattedText = formatText(text);
    return Text(
      formattedText,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
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

  String formatText(String text) {
    String formattedText = '';
    if (text.isNotEmpty) {
      var firstLetter = text[0];
      formattedText = firstLetter.toUpperCase() + text.substring(1);
    } else {
      formattedText = '';
    }
    return formattedText;
  }
}
