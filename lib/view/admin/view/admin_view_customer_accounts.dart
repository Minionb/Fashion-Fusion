import 'package:flutter/material.dart';

class AdminViewCustAcc extends StatelessWidget {
  const AdminViewCustAcc({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("User Accounts"),

          /// Search Bar (Enter Account Name)
          /// List of user accounts
        ],
      ),
    ));
  }
}
