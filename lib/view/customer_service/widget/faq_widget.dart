import 'package:fashion_fusion/view/customer_service/screen/help_desc_screen.dart';
import 'package:flutter/material.dart';

class FAQWidget extends StatelessWidget {
  final Map<String, dynamic> faqItem;
  // final String title;
  // final String desc;
  //final Widget routeWidget;

  const FAQWidget({
    super.key, 
    // required this.title, 
    // required this.desc, 
    required this.faqItem, 
    //required this.routeWidget
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HelpDesc(faqItem: faqItem,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(faqItem["title"], style: const TextStyle(fontWeight: FontWeight.bold),)
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                )
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}