import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class FAQData {
  Future<List<Map<String, dynamic>>> getFAQData() async {
    final String jsonString = await rootBundle.loadString('assets/faq_data.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonList);
  }
}