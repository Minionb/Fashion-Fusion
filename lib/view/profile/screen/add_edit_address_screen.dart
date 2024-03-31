import 'package:fashion_fusion/config/theme/app_theme.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditAddressScreen extends StatefulWidget {
  final Address? address;

  const EditAddressScreen({super.key, this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late Address address;
  late TextEditingController _nickNameController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _zipCodeController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _nickNameController = TextEditingController();
    _addressLine1Controller = TextEditingController();
    _addressLine2Controller = TextEditingController();
    _zipCodeController = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();
    if (widget.address != null) {
      _nickNameController.text = widget.address!.addressNickName ?? '';
      _addressLine1Controller.text = widget.address!.addressLine1 ?? '';
      _addressLine2Controller.text = widget.address!.addressLine2 ?? '';
      _zipCodeController.text = widget.address!.zipCode ?? '';
      _cityController.text = widget.address!.city ?? '';
      _countryController.text = widget.address!.country ?? 'Canada';
    } else {
      _countryController.text = 'Canada';
    }
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address != null ? 'Edit Address' : 'Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildFormSection(), _buildButtonSection(context)]),
      ),
    );
  }

  Column _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
            controller: _nickNameController, labelText: 'Address Nickname'),
        _buildTextField(
            controller: _addressLine1Controller, labelText: 'Address Line 1'),
        _buildTextField(
            controller: _addressLine2Controller, labelText: 'Address Line 2'),
        _buildTextField(
            controller: _zipCodeController,
            labelText: 'Zip Code',
            capitalization: TextCapitalization.characters,
            inputFormatters: [
              LengthLimitingTextInputFormatter(7),
              CanadianPostalCodeFormatter()
            ]),
        _buildTextField(controller: _cityController, labelText: 'City'),
        // Only support Canada as country
        _buildTextField(controller: _countryController, labelText: 'Country', readOnly: false),
        const SizedBox(height: 16),
      ],
    );
  }

  Column _buildButtonSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle save button action
                // Example: saveAddress()
              },
              style: AppTheme.primaryButtonStyle(),
              child: const Text('Save Address',
                  style: TextStyle(color: Colors.white)),
            ),
          )
        ]),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      bool readOnly = false,
      ValueChanged<String>? onChanged,
      TextCapitalization capitalization = TextCapitalization.none,
      List<TextInputFormatter> inputFormatters = const []}) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: _decorateTextField(labelText),
            readOnly: readOnly,
            onChanged: onChanged,
            textCapitalization: capitalization,
            inputFormatters: inputFormatters,
          ),
        ),
      ],
    );
  }

  InputDecoration _decorateTextField(String labelText) {
    return InputDecoration(
      labelText: labelText,
      floatingLabelStyle: TextStyle(
        color: AppColors.primary,
      ),
      focusColor: AppColors.primary,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primary, // Default bottom border color
        ),
      ),
    );
  }
}

class CanadianPostalCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final formattedValue = _formatCanadianPostalCode(newValue.text);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatCanadianPostalCode(String value) {
    // Remove all non-alphanumeric characters from the input
    final cleanedValue = value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    if (cleanedValue.length <= 6) {
      final firstPart = cleanedValue.substring(0, cleanedValue.length > 3 ? 3 : cleanedValue.length);
      final secondPart = cleanedValue.length > 3 ? ' ${cleanedValue.substring(3)}' : '';
      return '$firstPart$secondPart';
    } else {
      return cleanedValue.substring(0, 6);
    }
  }
}