import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:fashion_fusion/data/profile/model/profile_model.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile/profile_cubit.dart';
import 'package:fashion_fusion/view/auth/screen/welcome_screen.dart';
import 'package:fashion_fusion/view/profile/screen/customer_order_list.dart';
import 'package:fashion_fusion/view/profile/screen/profile_payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:toastification/toastification.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetails();
}

class _ProfileDetails extends State<ProfileDetails> {
  final profileFirstName = "";
  final profileLastName = "";
  var profile;

  @override
  Widget build(BuildContext context) {
    print(sl<SharedPreferences>().getString("userID"));

    /// Details
    return HelperMethod.loader(
        child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text("My profile",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                  ),
                  BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                    if (state is ProfileIsLoadingState) {
                      print("Profile LOADING");
                      context.loaderOverlay.show();
                    }
                    if (state is ProfileLoadedState) {
                      context.loaderOverlay.hide();
                      profile = state.model;
                      print("Profile LOADED");
                      return ProfileTitle(
                        name: "${profile.firstName} ${profile.lastName}",
                        email: profile.email!,
                        payments: state.model!.payments,
                      );
                    }
                    if (state is ProfileErrorState) {
                      context.loaderOverlay.hide();
                      HelperMethod.showToast(context,
                          title: Text(state.errorMessage),
                          type: ToastificationType.error);
                    }
                    return const SizedBox();
                  }),
                ],
              ),
            )));
  }
}

class ProfileTitle extends StatelessWidget {
  final String name;
  final String email;
  final List<PaymentModel> payments;

  const ProfileTitle({
    super.key,
    required this.name,
    required this.email,
    required this.payments
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.lightBlue[400]),
              child: Center(
                  child: Text(name.substring(0, 1),
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
                  child: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(email,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12))),
              ],
            )
          ],
        ),
        const Padding(padding: EdgeInsets.all(15)),
        ProfileOptionsCard(
            title: "My orders",
            subtitle: "Already have [] orders",
            routeWidget: CustomerOrderListScreen()),
        ProfileOptionsCard(
            title: "Shipping addresses",
            subtitle: "[] addresses",
            routeWidget: ProfilePaymentMethods(paymentMethodsList: payments)),
        ProfileOptionsCard(
            title: "Payment methods",
            subtitle: "Visa **[]",
            routeWidget: ProfilePaymentMethods(paymentMethodsList: payments)),
        ProfileOptionsCard(
            title: "Settings",
            subtitle: "Notifications, password",
            routeWidget: ProfilePaymentMethods(paymentMethodsList: payments)),
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

  const ProfileOptionsCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.routeWidget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => routeWidget));
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
        ));
  }
}

class SignOutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget routeWidget;

  const SignOutCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.routeWidget});

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
        ));
  }
}
