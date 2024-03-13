import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/provider/cart_cubit/cart/cart_cubit.dart';
import 'package:fashion_fusion/provider/customerCubit/customer/customer_cubit.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite/favorite_cubit.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite_edit/favorite_edit_cubit.dart';
import 'package:fashion_fusion/provider/product_cubit/product/product_cubit.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile/profile_cubit.dart';
import 'package:fashion_fusion/view/home/screen/cart_screen.dart';
import 'package:fashion_fusion/view/home/screen/favorite_screen.dart';
import 'package:fashion_fusion/view/home/screen/home_screen.dart';
import 'package:fashion_fusion/view/profile/screen/profile_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
      
        get productQueryParams => null;

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: AppColors.bg, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.

      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.simple, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteCubit>(
            create: (context) => sl<FavoriteCubit>()..getFavorite(),
          ),
          BlocProvider<FavoriteEditCubit>(
            create: (context) => sl<FavoriteEditCubit>(),
          ),
          BlocProvider<CartCubit>(
            create: (context) => sl<CartCubit>()..getCartItems(),
          ),
          BlocProvider<ProductCubit>(
            create: (context) => sl<ProductCubit>()..getProduct(productQueryParams),
          ),
        ],
        child: const HomeScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<CustomerCubit>(
            create: (context) => sl<CustomerCubit>()
              ..getCustomerById(sl<SharedPreferences>().getString("userID")!),
          ),
          BlocProvider<CartCubit>(
            create: (context) => sl<CartCubit>()..getCartItems(),
          ),
        ],
        child: const CartScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteCubit>(
            create: (context) => sl<FavoriteCubit>()..getFavorite(),
          ),
          BlocProvider<FavoriteEditCubit>(
            create: (context) => sl<
                FavoriteEditCubit>(), // Assuming you have registered FavoriteEditCubit in your dependency injection
          ),
          BlocProvider<CartCubit>(
            create: (context) => sl<CartCubit>()..getCartItems(),
          ),
        ],
        child: const ViewFavoritesScreen(),
      ),
      BlocProvider(
        create: (context) => sl<ProfileCubit>()
          ..getProfile(sl<SharedPreferences>().getString("userID")!),
        child: const ProfileDetails(),
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: "Home",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.cart),
        title: "Cart",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.heart),
        title: "favorite",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person),
        title: "Profile",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
