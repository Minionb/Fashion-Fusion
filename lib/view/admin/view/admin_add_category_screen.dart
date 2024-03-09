import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/widgets/custom_button.dart';
import 'package:fashion_fusion/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminAddCategoryScreen extends StatefulWidget {
  const AdminAddCategoryScreen({super.key});

  @override
  State<AdminAddCategoryScreen> createState() => _AdminAddCategoryScreenState();
}

class _AdminAddCategoryScreenState extends State<AdminAddCategoryScreen> {
  final _nameCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0).w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(label: "Name", hint: "ex: Tops", ctrl: _nameCtrl),
              50.verticalSpace,
              CustomButton(
                label: "Save",
                bg: AppColors.primary,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
