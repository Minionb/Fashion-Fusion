import 'package:fashion_fusion/config/theme/app_theme.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/profile/model/profile_model.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile_edit/profile_edit_cubit.dart';
import 'package:fashion_fusion/view/profile/screen/add_payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';

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
        appBar: AppBar(
          title: const Text("Payment methods"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < paymentMethodsList.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: PaymentOptionsCard(
                    paymentMethod: paymentMethodsList[i],
                  ),
                ),
              _buildAddPaymentButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddPaymentButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              toAddPaymentMethod(context, paymentMethodsList);
            },
            style: AppTheme.primaryButtonStyle(),
            child: const Text(
              'Add payment',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void toAddPaymentMethod(
      BuildContext context, List<PaymentModel> paymentMethodsList) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => sl<ProfileEditCubit>(),
                  child: AddPaymentMethod(curPayments: paymentMethodsList),
                )));
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
            colors: _getCardTypeColorScheme(paymentMethod.method),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (paymentMethod.method.toUpperCase() == 'VISA')
                  Image.asset("assets/icons/visa.256x79.png",
                      width: 75, height: 30, fit: BoxFit.fill),
                if (paymentMethod.method.toUpperCase() == 'MASTERCARD')
                  Image.asset("assets/icons/mastercard.256x198.png",
                      width: 55, height: 40, fit: BoxFit.fill),
                if (paymentMethod.method.toUpperCase() == 'AMERICAN EXPRESS')
                  Image.asset("assets/icons/american-express.256x84.png",
                      width: 75, height: 30, fit: BoxFit.fill) 
              ],
            ),
            16.verticalSpace,
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                paymentMethod.cardNumber,
                style: TextStyle(
                    fontSize: 24.0,
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.bold,
                    color: paymentMethod.method == 'American Express'
                        ? Colors.black
                        : Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Card Holder Name",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: paymentMethod.method == 'American Express'
                              ? Colors.black
                              : Colors.white),
                    ),
                    Text(
                      paymentMethod.name,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: paymentMethod.method == 'American Express'
                              ? Colors.black
                              : Colors.white),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expiry Date",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: paymentMethod.method == 'American Express'
                              ? Colors.black
                              : Colors.white),
                    ),
                    Text(
                      paymentMethod.expirationDate,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: paymentMethod.method == 'American Express'
                              ? Colors.black
                              : Colors.white),
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

  List<Color> _getCardTypeColorScheme(String method) {
    Color primaryColor;
    Color secondaryColor;

    switch (method.toUpperCase()) {
      case 'VISA':
        primaryColor = AppColors.visaPrimary;
        secondaryColor = AppColors.visaSecondary;
        break;
      case 'MASTERCARD':
        primaryColor = AppColors.mastercardPrimary;
        secondaryColor = AppColors.mastercardSecondary;
        break;
      case 'AMERICAN EXPRESS':
        primaryColor = AppColors.americanEPrimary;
        secondaryColor = AppColors.americanESecondary;
        break;
      default:
        primaryColor = AppColors.grayDK;
        secondaryColor = AppColors.darkSeliverDK;
        break;
    }

    return [primaryColor, secondaryColor, primaryColor];
  }
}
