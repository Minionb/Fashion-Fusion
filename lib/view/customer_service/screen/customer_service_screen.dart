import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  @override
  State<CustomerService> createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Service")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Text("Hello, welcome to customer service. \n\nIf you required assistance, feel free to contact customer support at: customer.support@fasionfusion.com or give us a call at: 1-111-111-1111.",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
            ),
            10.verticalSpace,
            Text("FAQ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ],
        ),
      )
    );
  }
}