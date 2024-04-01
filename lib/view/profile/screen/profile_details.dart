import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/profile/model/profile_model.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile/profile_cubit.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile_edit/profile_edit_cubit.dart';
import 'package:fashion_fusion/view/auth/screen/welcome_screen.dart';
import 'package:fashion_fusion/view/customer_service/screen/customer_service_screen.dart';
import 'package:fashion_fusion/view/home/widget/app_bar.dart';
import 'package:fashion_fusion/view/profile/screen/change_password_screen.dart';
import 'package:fashion_fusion/view/profile/screen/profile_addresses_screen.dart';
import 'package:fashion_fusion/view/profile/screen/customer_order_list.dart';
import 'package:fashion_fusion/view/profile/screen/profile_payment_methods.dart';
import 'package:fashion_fusion/view/profile/screen/profile_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetails();
}

class _ProfileDetails extends State<ProfileDetails> {
  late ProfileModel profile;

  Future<void> _fetchProfile() async {
    setState(() {
      context.read<ProfileCubit>().getProfile(sl<SharedPreferences>().getString("userID")!);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(sl<SharedPreferences>().getString("userID"));

    /// Details
    return HelperMethod.loader(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return <Widget>[
                const HomescreenAppBar(title: "My Profile"),
              ];
            },
            body: _buildBody()
          ),
        )
      )
    );
  }

  Widget _buildBody() {
    return Center(
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadedState) {
            profile = state.model!;
            debugPrint("Profile LOADED");
            return _buildProfileBody();
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                _fetchProfile();
              },
              child: const Center(
                child: CircularProgressIndicator(),
              ), 
            );
          }
        }
      ),
    );
  }

  Widget _buildProfileBody() {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchProfile();
      },
      child: ProfileTitle(
        profile: profile,
      )
    );
  }
}

class ProfileTitle extends StatelessWidget {
  final ProfileModel profile;

  const ProfileTitle({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.lightBlue[400]),
                child: Center(
                  child: Text(profile.firstName!.substring(0, 1),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("${profile.firstName} ${profile.lastName}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(profile.email!,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12))),
                ],
              )
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(15)),
        ProfileOptionsCard(
            title: "My orders",
            subtitle: "Already have [] orders",
            routeWidget: CustomerOrderListScreen()),
        ProfileOptionsCard(
            title: "Shipping addresses",
            subtitle: "[] addresses",
            routeWidget: AddressListScreen()),
        ProfileOptionsCard(
            title: "Payment methods",
            subtitle: profile.payments.isNotEmpty ? "${profile.payments[0].method} **${profile.payments[0].cardNumber.substring(17)}" : "No saved payment methods",
            routeWidget: ProfilePaymentMethods(paymentMethodsList: profile.payments)),
        ProfileOptionsCard(
            title: "Settings",
            subtitle: "Email",
            routeWidget: BlocProvider(
                create: (context) => sl<ProfileEditCubit>(),
                child: ProfileSettings(profile: profile,),
            ),
        ),
        ProfileOptionsCard(
            title: "Security",
            subtitle: "Password",
            routeWidget: BlocProvider(
                create: (context) => sl<AuthCubit>(),
                child: const ChangePasswordScreen(),
            ),
        ),
        ProfileOptionsCard(
            title: "Customer Service",
            subtitle: "FAQ, Help",
            routeWidget: CustomerService()),
        const SignOutCard(
            title: "Sign Out",
            subtitle: "Sign out from your account",
            routeWidget: WelcomePage()),
      ],
    );
  }
}

class ProfileOptionsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget routeWidget;

  const ProfileOptionsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.routeWidget
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(builder: (context) =>           
            MultiBlocProvider(
              providers: [
                BlocProvider<AuthCubit>(
                  create: (context) => sl<AuthCubit>(),
                ),
                BlocProvider<ProfileCubit>(
                  create: (context) => sl<ProfileCubit>(),
                ),
                BlocProvider<ProfileEditCubit>(
                  create: (context) => sl<ProfileEditCubit>(),
                ),
              ],
              child: routeWidget,
            ),
          )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                )
              ],
            ),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      )
    );
  }
}

class SignOutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget routeWidget;

  const SignOutCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.routeWidget
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Sign Out'),
              content: const Text('Are you sure you want to sign out?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => routeWidget),
                    );
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                )
              ],
            ),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      )
    );
  }
}
