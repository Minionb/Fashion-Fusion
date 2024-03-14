import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:fashion_fusion/data/profile/model/profile_model.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile/profile_cubit.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile_edit/profile_edit_cubit.dart';
import 'package:fashion_fusion/view/profile/add_payment_method.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';

// class ProfilePaymentMethods extends StatefulWidget {
//   const ProfilePaymentMethods({super.key});

//   @override
//   State<ProfilePaymentMethods> createState() => _ProfilePaymentMethods();
// }

class ProfilePaymentMethods extends StatelessWidget {
  late final List<PaymentModel> paymentMethodsList;
  List<PaymentModel> newPaymentMethodsList = [];

  ProfilePaymentMethods({
    super.key, 
    required this.paymentMethodsList,
  });

  @override
  Widget build(BuildContext context) {
    return HelperMethod.loader(
      child: Scaffold(
        appBar: AppBar(title: const Text("Payment methods"),),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Your payment cards", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              /// Cards of entered payment methods
              const Padding(padding: EdgeInsets.all(5)),
              // BlocBuilder<ProfileCubit, ProfileState>(
              //   builder: (context, state) {
              //     if (state is ProfileIsLoadingState) {
              //       print("Profile LOADING");
              //       context.loaderOverlay.show();
              //     }
              //     if (state is ProfileLoadedState) {
              //       context.loaderOverlay.hide();
              //       if (state.model!.payments!.isNotEmpty) {
              //         paymentMethodsList = state.model!.payments;
              //         return 
              //       }
              //       else {
              //         return Text("No saved payment methods");
              //       }
              //     }
              //   }
              // ),
              paymentMethodsList.isNotEmpty ? Expanded(
                child: ListView.builder(
                  itemCount: paymentMethodsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: PaymentOptionsCard(paymentMethod: paymentMethodsList[index])
                    );
                  }
                )
              )
              : 
              const Center(
                child: Text("No saved payment methods")
              ),
              const Padding(padding: EdgeInsets.all(5)),
              //const Expanded(child: Spacer()),
              Row(
                children: [
                  const Expanded(child: Spacer()),
                  FloatingActionButton(onPressed: () {
                      toAddPaymentMethod(context, paymentMethodsList);
                    },
                    child: const Text("+", style: TextStyle(fontSize: 25)),
                  ),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}

class PaymentOptionsCard extends StatelessWidget {
  final PaymentModel paymentMethod;

  const PaymentOptionsCard({
    super.key, 
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0)
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(paymentMethod.method),
            SizedBox(height: 8.0),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("**** **** **** ${paymentMethod.cardNumber!.substring(paymentMethod.cardNumber!.length - 4)}",
                style: const TextStyle(
                  fontSize: 24.0,
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Card Holder Name",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(paymentMethod.name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Expiry Date",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(paymentMethod.expirationDate,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

void toAddPaymentMethod(BuildContext context, List<PaymentModel> paymentMethodsList) async {
  //Navigator.of(context).push(route)

  // Navigator.pushReplacement(
  //     context, MaterialPageRoute(builder: (context) => AddPaymentMethod(curPayments: paymentMethodsList)));

  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => BlocProvider(
        create: (context) => sl<ProfileEditCubit>(),
        child: AddPaymentMethod(curPayments: paymentMethodsList),
      )));

}