import 'package:fashion_fusion/view/profile/add_payment_method.dart';
import 'package:flutter/material.dart';

class ProfilePaymentMethods extends StatelessWidget {
  const ProfilePaymentMethods({super.key});

  void toAddPaymentMethod(BuildContext context) {
    //Navigator.of(context).push(route)

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddPaymentMethod()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment methods"),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your payment cards", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            /// Cards of entered payment methods
            const Padding(padding: EdgeInsets.all(20)),
            Text("No saved payment methods"),
            const Padding(padding: EdgeInsets.all(20)),
            const Expanded(child: Spacer()),
            Row(
              children: [
                const Expanded(child: Spacer()),
                FloatingActionButton(onPressed: () {
                  toAddPaymentMethod(context);
                  },
                  child: const Text("+", style: TextStyle(fontSize: 25)),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
