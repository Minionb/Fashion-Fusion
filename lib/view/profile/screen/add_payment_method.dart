import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/helper_validation.dart';
import 'package:fashion_fusion/core/widgets/custom_button.dart';
import 'package:fashion_fusion/core/widgets/custom_text_field.dart';
import 'package:fashion_fusion/data/profile/model/profile_model.dart';
import 'package:fashion_fusion/data/profile/model/upload_profile_model.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile_edit/profile_edit_cubit.dart';
import 'package:fashion_fusion/view/profile/screen/profile_payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Add more payment options
const List<String> paymentOpsList = <String>['VISA', 'Mastercard', 'American Express'];

class AddPaymentMethod extends StatefulWidget {
  final List<PaymentModel> curPayments;

  const AddPaymentMethod({super.key, required this.curPayments});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethod();
}

class _AddPaymentMethod extends State<AddPaymentMethod> {
  final _formKey = GlobalKey<FormState>();
  final _holderFirstNameCtrl = TextEditingController();
  final _holderLastNameCtrl = TextEditingController();
  final _cardNumCtrl = TextEditingController();
  //final _expDateCtrl = TextEditingController();
  final _expDateMonthCtrl = TextEditingController();
  final _expDateYearCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  String selectedMethod = "";

  void handleDropdownValueChanged(String newValue) {
    setState(() {
      selectedMethod = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileEditCubit>(
      create: (context) => sl<ProfileEditCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Add new payment methods"),),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Select Payment Type"),
                // Drop down menu of types (VISA, Master Card, Paypal, Apple Pay)
                DropDownMenu(onValueChanged: handleDropdownValueChanged,),
                // Display different options depending on selected payment method
                // VISA and Master Card
                const Spacer(),
                const Text("Card Holder"),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        validator:(p0) => 
                            ValidationHelper.firstNameValidation(p0),
                        label: "First Name", 
                        hint: "John", 
                        ctrl: _holderFirstNameCtrl
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: CustomTextField(
                        validator:(p0) => 
                            ValidationHelper.secondNameValidation(p0),
                        label: "Last Name", 
                        hint: "Smith", 
                        ctrl: _holderLastNameCtrl
                      ),
                    )
                  ],
                ),
                const Spacer(),
                CustomTextField(
                  label: "Card Number", 
                  hint: "1234 1234 1234 1234", 
                  ctrl: _cardNumCtrl,
                  validator:(p0) => ValidationHelper.cardNumberValidation(p0, selectedMethod),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                const Spacer(),
                //const Text("Expiration Date"),
                // TextField(
                //   controller: _expDateCtrl,
                //   decoration: const InputDecoration(
                //     icon: Icon(Icons.calendar_today),
                //     labelText: "Enter Date"
                //   ),
                //   readOnly: true,
                //   onTap: () async {
                //     DateTime? pickedDate = await showDatePicker(
                //       context: context, 
                //       initialDate: DateTime.now(),
                //       firstDate: DateTime.now(), 
                //       lastDate: DateTime(2101)
                //     );
                //     if (pickedDate != null) {
                //       String formattedDate = DateFormat("MM/yyyy").format(pickedDate);
                //       setState(() {
                //         _expDateCtrl.text = formattedDate;
                //       });
                //     }
                //     else {
                //       print("Exp Date Not Seleceted");
                //     }
                //   },
                // ),
                const Text("Card Expiration Date"),
                Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        validator:(p0) => 
                            ValidationHelper.cardExpMonthValidation(p0),
                        label: "Month", 
                        hint: "01", 
                        ctrl: _expDateMonthCtrl
                      ),
                    ),
                    10.horizontalSpace,
                    Column(
                      children: [
                        20.verticalSpace,
                        const Text("/", style: TextStyle(fontSize: 30),),
                      ],
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: CustomTextField(
                        validator:(p0) => 
                            ValidationHelper.cardExpYearValidation(p0, int.parse(DateFormat("yyyy").format(DateTime.now())), int.parse(_expDateMonthCtrl.text), int.parse(DateFormat("MM").format(DateTime.now()))),
                        label: "Year", 
                        hint: DateFormat("yyyy").format(DateTime.now()), 
                        ctrl: _expDateYearCtrl
                      ),
                    )
                  ],
                ),
                const Spacer(),
                CustomTextField(
                  label: "CVV", 
                  hint: "123", 
                  ctrl: _cvvCtrl,
                  validator: (p0) => ValidationHelper.cardCVVValidation(p0),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                const Spacer(),
                // BlocListener<ProfileEditCubit, ProfileEditState>(
                //   listener: (context, state) {
                //     if (state is ProfileEditIsLoadingState) {
                //       context.loaderOverlay.show();
                //     }
                //     if (state is ProfileEditErrorState) {
                //       context.loaderOverlay.hide();
                //       HelperMethod.showToast(context,
                //               title: Text(state.message),
                //               type: ToastificationType.error);
                //     }
                //   },
                //   child: CustomButton(
                //     onPressed: () {
                //       if (selectedMethod != "") {
                //         if (_formKey.currentState!.validate()) {
                //           widget.curPayments.add(PaymentModel(
                //             name: "${_holderFirstNameCtrl.text} ${_holderLastNameCtrl.text}", 
                //             method: selectedMethod, 
                //             cardNumber: _cardNumCtrl.text, 
                //             expirationDate: _expDateCtrl.text,
                //             cvv: _cvvCtrl.text
                //           ));
                //           print(widget.curPayments);
                //           context.read<ProfileEditCubit>().updateProfile(
                //             UploadProfileModel(dictionary: 'payments', newData: widget.curPayments), 
                //             sl<SharedPreferences>().getString("userID")!
                //           );
                //           showDialog(
                //             context: context, 
                //             builder: (BuildContext context1) {
                //               return AlertDialog(
                //                 title: const Text(
                //                   'Successfully added payment method!'),
                //                 actions: <Widget>[
                //                   TextButton(
                //                     onPressed: () {
                //                       Navigator.pop(context1);
                //                     },
                //                     child: const Text('Cancel'),
                //                   ),
                //                   TextButton(
                //                     onPressed: () {
                //                       Navigator.pop(context1);
                //                       //Navigator.pop(context);
                //                       Navigator.pushReplacement(
                //                         context, MaterialPageRoute(builder: (context) => ProfilePaymentMethods(paymentMethodsList: widget.curPayments)));
                //                       //Navigator.of(context).pop(widget.curPayments);
                //                     }, 
                //                     child: const Text('OK')
                //                   )
                //                 ],
                //               );
                //             }
                //           );
                //         }
                //       }
                //     },
                //     label: "Save",
                //     bg: AppColors.primary,
                //   ),
                // ),
                CustomButton(
                  onPressed: () {
                    if (selectedMethod != "") {
                      if (_formKey.currentState!.validate()) {
                        // BlocProvider.of<ProfileEditCubit>(this.context).updateProfile(
                        //   UploadProfileModel(dictionary: 'payments', newData: widget.curPayments), 
                        //   sl<SharedPreferences>().getString("userID")!
                        // );
                        showDialog(
                          context: context, 
                          builder: (BuildContext context1) {
                            return AlertDialog(
                              title: const Text(
                                'Save payment method?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context1);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    widget.curPayments.add(PaymentModel(
                                      name: "${_holderFirstNameCtrl.text} ${_holderLastNameCtrl.text}", 
                                      method: selectedMethod, 
                                      cardNumber: _cardNumCtrl.text, 
                                      expirationDate: "${_expDateMonthCtrl.text}/${_expDateYearCtrl.text}",
                                      cvv: _cvvCtrl.text
                                    ));
                                    print(widget.curPayments);
                                    // BlocProvider.of<ProfileEditCubit>(context).updateProfile(
                                      // UploadProfileModel(dictionary: 'payments', newData: widget.curPayments), 
                                      // sl<SharedPreferences>().getString("userID")!
                                    // );
                                    List<Map<String, dynamic>> jsonListCurPayments = widget.curPayments.map((e) => e.toJson()).toList();
                                    print(jsonListCurPayments);
                                    context.read<ProfileEditCubit>().updateProfile(
                                      UploadProfileModel(dictionary: 'payments', newData: jsonListCurPayments), 
                                      sl<SharedPreferences>().getString("userID")!
                                    );
                                    Navigator.pop(context1);
                                    showDialog(
                                      context: context, 
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Successfully added payment method!"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }, 
                                              child: const Text("Ok"))
                                          ],
                                        );
                                      }
                                    );
                                    //Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => ProfilePaymentMethods(paymentMethodsList: widget.curPayments)));
                                    //Navigator.of(context).pop(widget.curPayments);
                                  }, 
                                  child: const Text('Save')
                                )
                              ],
                            );
                          }
                        );
                      }
                    }
                  },
                  label: "Save",
                  bg: AppColors.primary,
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

class DropDownMenu extends StatefulWidget {
  final void Function(String)? onValueChanged;

  const DropDownMenu({super.key, this.onValueChanged});

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

        if (widget.onValueChanged != null) {
          widget.onValueChanged!(dropdownValue);
        }
      },
      dropdownMenuEntries: paymentOpsList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}