import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_images.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';
import 'package:fashion_fusion/provider/states/cubit_states.dart';
import 'package:fashion_fusion/view/auth/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userEmail = "Welcome";
  String username = "Admin";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // _header(),
            BlocListener<AuthCubit, CubitState>(
              listener: (context, state) async {
                if (state is DataLoading) {
                  HelperMethod.loadinWidget();
                }
                if (state is DataSuccess) {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const WelcomePage();
                      },
                    ),
                    (_) => false,
                  );
                }
              },
              child: ListTile(
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                dense: true,
                style: ListTileStyle.drawer,
                title: const Text("Logout"),
                leading: const Icon(Icons.logout),
              ),
            ),
            const Divider(),
            const Spacer(),
            Text(
              "Powered by Centennial College",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 30), // Adjusted to SizedBox
          ],
        ),
      ),
    );
  }

  DrawerHeader _header() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: UserAccountsDrawerHeader(
        currentAccountPicture: Image.asset(
          AppImages.googleLogo,
          fit: BoxFit.cover,
          width: 400.sp,
        ),
        accountName: Text(
          username,
          style: TextStyle(fontSize: 12.sp),
        ),
        accountEmail: Text(
          userEmail,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action
                context.read<AuthCubit>().signOut();
                Navigator.pop(context);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
