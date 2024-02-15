import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Tab bar
    /// Details
    /// Payment Methods
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Profile pic here
            Text("Hi, [NAME HERE]"),
            Row(
              children: [
                Text("First Name"),
                Text("Last Name"),
              ],
            ),
            Row(
              children: [
                Text(""), // First name
                Text(""), // Last name
              ],
            ),
            Text("Birthday"),
            Text(""), // Birthday mm-dd-yyyy
            Text("Email"),
            Text(""),
            Text("Phone"),
            Text(""),
            Text("Shipping Address:"),
            Text(""),
            Text("Change Password"),
            Text(""),
            Text("Payment Methods"),
            Text(""),
          ],
        ),
      ),
    );
  }
}