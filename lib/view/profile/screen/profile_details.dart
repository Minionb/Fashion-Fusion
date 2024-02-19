import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/data/auth/model/status_model.dart';
import 'package:fashion_fusion/view/profile/screen/profile_payment_methods.dart';
import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    /// Details
    /// Payment Methods
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("My profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            ),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.lightBlue[400]
                  ),
                  child: const Center(
                    child: Text("T", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),)
                  ),
                ),
                const Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("[NAME HERE]", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("[EMAIL HERE]", style: TextStyle(color: Colors.grey, fontSize: 12))
                    ),
                  ],
                )
              ],
            ),
            const Padding(padding: EdgeInsets.all(15)),
            const ProfileOptionsCard(title: "My orders", subtitle: "Already have [] orders", routeWidget: ProfilePaymentMethods()),
            const ProfileOptionsCard(title: "Shipping addresses", subtitle: "[] addresses", routeWidget: ProfilePaymentMethods()),
            const ProfileOptionsCard(title: "Payment methods", subtitle: "Visa **[]", routeWidget: ProfilePaymentMethods()),
            const ProfileOptionsCard(title: "Settings", subtitle: "Notifications, password", routeWidget: ProfilePaymentMethods()),
          ],
        ),
      )
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

  @override Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => routeWidget));
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey,)
              ],
            ),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            
          ],
        ),
      )
    );
  }
}