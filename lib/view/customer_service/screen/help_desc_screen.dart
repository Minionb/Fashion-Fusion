import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpDesc extends StatelessWidget {
  final Map<String, dynamic> faqItem;
  // final String title;
  // final String desc;
  // final String content;

  const HelpDesc({
    super.key, 
    // required this.title, 
    // required this.desc, 
    // required this.content, 
    required this.faqItem
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Help"),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(faqItem["title"], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            10.verticalSpace,
            Divider(
              color: Colors.grey[350],
              height: 1,
              thickness: 1,
            ),
            10.verticalSpace,
            Text(faqItem["content"], style: TextStyle(fontSize: 15),)
          ],
        ),
      ),
    );
  }
}