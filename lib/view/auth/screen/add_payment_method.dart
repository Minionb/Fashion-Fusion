import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const List<String> paymentOpsList = <String>['VISA', 'Master Card', 'Paypal', 'Apple Pay'];

class AddPaymentMethod extends StatefulWidget {
  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethod();
}

class _AddPaymentMethod extends State<AddPaymentMethod> {
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Select Payment Type"),
          // Drop down menu of types (VISA, Master Card, Paypal, Apple Pay)
          DropDownMenu(),
          // Display different options depending on selected payment method
          // VISA and Master Card
          const Text("Card Number"),
          TextField(
            maxLength: 16,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ],
          ), /// 
          const Text("Expiration Date"),
          TextField(
            controller: dateController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: "Enter Date"
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context, 
                initialDate: DateTime.now(),
                firstDate: DateTime(2000), 
                lastDate: DateTime(2101)
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat("MM-yy").format(pickedDate);
                setState(() {
                  dateController.text = formattedDate;
                });
              }
              else {
                print("Exp Date Not Seleceted");
              }
            },
          ),
          const Text("CVV"),
          TextField(
            maxLength: 3,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ]
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}

class DropDownMenu extends StatefulWidget {
  const DropDownMenu({super.key});

  @override
  State<DropDownMenu> createState() => _DropDownMenu();
}

class _DropDownMenu extends State<DropDownMenu> {
  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: "Not Selected",
      onSelected: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: paymentOpsList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}