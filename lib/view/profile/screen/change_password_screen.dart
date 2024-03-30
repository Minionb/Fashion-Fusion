import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/auth/model/set_password.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';
import 'package:fashion_fusion/provider/states/cubit_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool _showPassword = false;
  List<String> _errors = [];
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: BlocConsumer<AuthCubit, CubitState>(
        listener: (context, state) {
          if (state is DataSuccess) {
            HelperMethod.showToast(context,
                title: const Text("Password updated"),
                type: ToastificationType.success);
            Navigator.of(context).pop();
          }
          if (state is DataFailure) {
            setState(() {
              _isProcessing = false;
            });
            HelperMethod.showToast(context,
                title: const Text("Password update failed"),
                type: ToastificationType.error);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTextFieldSection(state),
                buildButtonSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Column buildButtonSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ChangePasswordButton(
          isProcessing: _isProcessing,
          errors: _errors,
          onPressed: () {
            // Check if passwords match and meet criteria before dispatching the event
            _errors = _validatePasswords();
            if (_errors.isEmpty) {
              setState(() {
                _isProcessing = true;
              });
              context.read<AuthCubit>().setPassword(
                    SetPasswordModel(
                      oldPassword: _oldPasswordController.text,
                      password: _newPasswordController.text,
                    ),
                  );
            }
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  List<String> _validatePasswords() {
    List<String> errors = [];

    // Check if new password is different from old password
    if (_newPasswordController.text == _oldPasswordController.text) {
      errors.add('New password should be different');
    }

    // Check if new password meets minimum length requirement
    if (_newPasswordController.text.length < 6) {
      errors.add('Password must be at least 6 characters long');
    }

    // Check if new password and confirm password match
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      errors.add('Passwords do not match');
    }

    return errors;
  }

  Column buildTextFieldSection(state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildPasswordTextField(
          controller: _oldPasswordController,
          labelText: 'Old Password',
          onChanged: onPasswordChanged,
        ),
        const SizedBox(height: 16.0),
        buildPasswordTextField(
          controller: _newPasswordController,
          labelText: 'New Password',
          onChanged: onPasswordChanged,
        ),
        const SizedBox(height: 16.0),
        buildPasswordTextField(
          controller: _confirmNewPasswordController,
          labelText: 'Confirm New Password',
          onChanged: onPasswordChanged,
        ),
        if (_errors.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _errors
                .map((error) => Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(error,
                          style: const TextStyle(color: Colors.red)),
                    ))
                .toList(),
          ),
        const SizedBox(height: 16.0)
      ],
    );
  }

  Column buildErrorSection(state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (_errors.isNotEmpty)
          Column(
            children: _errors
                .map((error) => Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ))
                .toList(),
          ),
        const SizedBox(height: 16.0),
        if (state is DataFailure)
          Text(
            'Password update failed!',
            style: TextStyle(color: AppColors.primary),
          ),
      ],
    );
  }

  void onPasswordChanged(value) {
    setState(() {
      _errors = _validatePasswords();
    });
  }

  Widget buildPasswordTextField({
    required TextEditingController controller,
    required String labelText,
    ValueChanged<String>? onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: _decorateTextField(labelText),
            obscureText: !_showPassword,
            readOnly: _isProcessing,
            onChanged: onChanged,
          ),
        ),
        IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
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

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}

class ChangePasswordButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isProcessing;
  final List<String> errors;

  const ChangePasswordButton({
    super.key,
    required this.onPressed,
    required this.isProcessing,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isProcessing || errors.isNotEmpty ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isProcessing || errors.isNotEmpty
                  ? AppColors.disabled
                  : AppColors.primary,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text(
              'Change Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
