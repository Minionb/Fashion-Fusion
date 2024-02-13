import 'package:fashion_fusion/view/auth/screen/add_payment_method.dart';
import 'package:flutter/material.dart';

class ProfilePaymentMethods extends StatelessWidget {
  const ProfilePaymentMethods({super.key});

  void toAddPaymentMethod(BuildContext context) {
    //Navigator.of(context).push(route)

    Navigator.push(context, MaterialPageRoute(builder: (context) => AddPaymentMethod()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // InkWell(
            //   onTap: () {
            //     toAddPaymentMethod(context);
            //   },
            //   child: const Text("Add a payment method"),
            // ),
            const Text("Your payment cards"),
            /// Cards of entered payment methods
            
            FloatingActionButton(onPressed: () {
              toAddPaymentMethod(context);
            }),
          ],
        ),
      )
    );
  }
}