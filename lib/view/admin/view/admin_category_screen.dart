import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/view/admin/view/admin_add_category_screen.dart';
import 'package:fashion_fusion/view/admin/widget/admin_category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _addCategoryBtn(context),
      appBar: AppBar(
        title: const Text(
          "Category",
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return AdminCategoryCard(
              model: _cat[index],
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: _cat.length),
    );
  }

  Container _addCategoryBtn(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 90).w,
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(25).r),
        child: TextButton(
            onPressed: () {
              context.pushNamedNAV(const AdminAddCategoryScreen());
            },
            child: const Text(
              "Add Category",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }

  final List<String> _cat = [
    "Tops",
    "Bottoms",
    "Dresses",
    "Hoodies & Sweats",
    "Accessories",
  ];
}
