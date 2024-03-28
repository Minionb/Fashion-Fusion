import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/profile/model/profile_model.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile_edit/profile_edit_cubit.dart';
import 'package:fashion_fusion/view/profile/screen/add_payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              //Stack(
                //children: [
              paymentMethodsList.isNotEmpty ? 
                Expanded(
                  child: 
                  Stack(
                    children: [
                      ListView.builder(
                        itemCount: paymentMethodsList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PaymentOptionsCard(paymentMethod: paymentMethodsList[index])
                          );
                        }
                      ),
                      Positioned(
                        bottom: 16.0,
                        right: 16.0,
                        child: FloatingActionButton(onPressed: () {
                            toAddPaymentMethod(context, paymentMethodsList);
                          },
                          child: const Text("+", style: TextStyle(fontSize: 25)),
                        ),
                      )
                    ],
                  )
                )
              : 
              Stack(
                children: [
                  const Center(
                    child: Text("No saved payment methods")
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: FloatingActionButton(onPressed: () {
                        toAddPaymentMethod(context, paymentMethodsList);
                      },
                      child: const Text("+", style: TextStyle(fontSize: 25)),
                    ),
                  )
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
    String methodImage = "assets/icons/visa.256x79.png";

    return Card(
      elevation: 4.0,
      color: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(
            colors: [
              paymentMethod.method == 'VISA' ? AppColors.visaPrimary 
                : paymentMethod.method == 'Mastercard' ? AppColors.mastercardPrimary 
                  : AppColors.americanEPrimary,
              paymentMethod.method == 'VISA' ? AppColors.visaSecondary
                : paymentMethod.method == 'Mastercard' ? AppColors.mastercardSecondary
                  : AppColors.americanESecondary,
              paymentMethod.method == 'VISA' ? AppColors.visaPrimary 
                : paymentMethod.method == 'Mastercard' ? AppColors.mastercardPrimary 
                  : AppColors.americanEPrimary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Expanded(
                  child: Spacer()
                ),
                paymentMethod.method == 'VISA' ?  Image.asset(
                  "assets/icons/visa.256x79.png",
                  width: 75,
                  height: 30,
                  fit: BoxFit.fill
                )
                : paymentMethod.method == 'Mastercard' ? 
                Image.asset(
                  "assets/icons/mastercard.256x198.png",
                  width: 55,
                  height: 40,
                  fit: BoxFit.fill
                )
                : 
                Image.asset(
                  "assets/icons/american-express.256x84.png",
                  width: 75,
                  height: 30,
                  fit: BoxFit.fill
                ),
              ],
            ),
            15.verticalSpace,
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("**** **** **** ${paymentMethod.cardNumber.substring(paymentMethod.cardNumber.length - 4)}",
                style: TextStyle(
                  fontSize: 24.0,
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.bold,
                  color: paymentMethod.method == 'American Express' ? Colors.black : Colors.white
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Card Holder Name",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: paymentMethod.method == 'American Express' ? Colors.black : Colors.white
                      ),
                    ),
                    Text(paymentMethod.name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: paymentMethod.method == 'American Express' ? Colors.black : Colors.white
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
                        fontWeight: FontWeight.bold,
                        color: paymentMethod.method == 'American Express' ? Colors.black : Colors.white
                      ),
                    ),
                    Text(paymentMethod.expirationDate,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: paymentMethod.method == 'American Express' ? Colors.black : Colors.white
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

  // Navigator.pushReplacement(
  //     context, MaterialPageRoute(builder: (context) => AddPaymentMethod(curPayments: paymentMethodsList)));

  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => BlocProvider(
        create: (context) => sl<ProfileEditCubit>(),
        child: AddPaymentMethod(curPayments: paymentMethodsList),
      )));

}