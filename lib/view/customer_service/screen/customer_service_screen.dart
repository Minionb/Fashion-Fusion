import 'package:fashion_fusion/view/customer_service/widget/faq_data.dart';
import 'package:fashion_fusion/view/customer_service/widget/faq_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  @override
  State<CustomerService> createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {
  List<Map<String, dynamic>> faqData = [];

  @override
  void initState() {
    super.initState();
    loadFAQData();
  }

  Future<void> loadFAQData() async {
    final FAQData faqDataLoader = FAQData();
    final List<Map<String, dynamic>> data = await faqDataLoader.getFAQData();

    setState(() {
      faqData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Service")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello, welcome to customer service. \n\nIf you required assistance, feel free to contact customer support at: customer.support@fashionfusion.com or give us a call at: 1-111-111-1111.",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
            ),
            10.verticalSpace,
            Divider(
              color: Colors.grey[350],
              height: 1,
              thickness: 2,
            ),
            10.verticalSpace,
            const Text("FAQ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            Expanded(
              child: ListView.builder(
                itemCount: faqData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      FAQWidget(faqItem: faqData[index]),
                      5.verticalSpace,
                      Divider(
                        color: Colors.grey[400],
                        height: 1,
                        thickness: 1,
                      ),
                    ],
                  );
                }
              ),
            )
          ],
        ),
      )
    );
  }
}