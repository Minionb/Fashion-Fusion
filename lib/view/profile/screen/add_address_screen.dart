import 'package:fashion_fusion/config/theme/app_theme.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddAddressScreen extends StatefulWidget {
  List<Address> addressList;
  void Function(Address) onAddressSave;

  AddAddressScreen({super.key, required this.addressList, required this.onAddressSave});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
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
    _countryController = TextEditingController(text: 'Canada');
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
        title: const Text('Add Address'),
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
        _buildTextField(
            controller: _countryController,
            labelText: 'Country',
            readOnly: false),
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
                saveAddress();
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

  void saveAddress() {
    if (_validateFields()) {
      // All required fields are valid, proceed with saving the address
      String? addressNickName = _nickNameController.text;
      String? addressLine1 = _addressLine1Controller.text;
      String? addressLine2 = _addressLine2Controller.text;
      String? zipCode = _zipCodeController.text;
      String? city = _cityController.text;
      String? country = _countryController.text;

      Address newAddress = Address(
        addressNickName: addressNickName,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        zipCode: zipCode,
        city: city,
        country: country,
      );
      List<Address> newAddressList = List.from(widget.addressList);
      newAddressList.add(newAddress);
      List<Map<String, dynamic>> jsonListAddresses =
          newAddressList.map((e) => e.toJson()).toList();
      // context.read<ProfileEditCubit>().updateProfile(
      //     UploadProfileModel(
      //         dictionary: 'addresses', newData: jsonListAddresses),
      //     sl<SharedPreferences>().getString("userID")!);
      widget.onAddressSave(newAddress); 

                    Navigator.pop(context);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    TextCapitalization capitalization = TextCapitalization.none,
    List<TextInputFormatter> inputFormatters = const [],
  }) {
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

  bool _validateFields() {
    List<String> errors = [];

    if (_nickNameController.text.isEmpty) {
      errors.add('Address Nickname is required');
    }
    if (_addressLine1Controller.text.isEmpty) {
      errors.add('Address Line 1 is required');
    }
    if (_zipCodeController.text.isEmpty) {
      errors.add('Zip Code is required');
    } else if (_zipCodeController.text.length != 7 ||
        !_zipCodeController.text
            .contains(CanadianPostalCodeFormatter.zipCodeRegex)) {
      errors.add('Zip Code format is invalid (e.g., A1A 1A1)');
    }
    if (_cityController.text.isEmpty) {
      errors.add('City is required');
    }

    if (errors.isNotEmpty) {
      // Show an error message indicating all validation errors
      String errorMessage = 'Please correct the following errors:\n  - ';
      errorMessage += errors.join('\n  - ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 3), // Adjust as needed
        ),
      );
      return false;
    }

    return true;
  }
}

class CanadianPostalCodeFormatter extends TextInputFormatter {
  static final RegExp zipCodeRegex = RegExp(r'[^a-zA-Z0-9]');
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final formattedValue = _formatCanadianPostalCode(newValue.text);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatCanadianPostalCode(String value) {
    // Remove all non-alphanumeric characters from the input
    final cleanedValue = value.replaceAll(zipCodeRegex, '');
    if (cleanedValue.length <= 6) {
      final firstPart = cleanedValue.substring(
          0, cleanedValue.length > 3 ? 3 : cleanedValue.length);
      final secondPart =
          cleanedValue.length > 3 ? ' ${cleanedValue.substring(3)}' : '';
      return '$firstPart$secondPart';
    } else {
      return cleanedValue.substring(0, 6);
    }
  }
}
