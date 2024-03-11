import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/cart_decorator_utils.dart';
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:fashion_fusion/provider/cart_cubit/cart/cart_cubit.dart';
import 'package:fashion_fusion/provider/customerCubit/customer/customer_cubit.dart';
import 'package:fashion_fusion/view/widget/cart_item_widget.dart';
import 'package:fashion_fusion/view/home/widget/list_tile_product_image.dart';
import 'package:fashion_fusion/view/home/widget/total_amount_widget.dart';
import 'package:fashion_fusion/view/widget/address_card_widget.dart';
import 'package:fashion_fusion/view/widget/payment_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCheckoutScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final CartDecorator cartDecorator;

  const OrderCheckoutScreen({
    Key? key,
    required this.cartItems,
    required this.cartDecorator,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OrderCheckoutScreenState();
  }
}

class _OrderCheckoutScreenState extends State<OrderCheckoutScreen> {
  int selectedAddressIndex = 0;
  int selectedPaymentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerCubit>(
          create: (context) => sl<CustomerCubit>()
            ..getCustomerById(sl<SharedPreferences>().getString("userID")!),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Checkout",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderSummarySection(),
              _buildPaymentOptionsSection(),
              _buildShippingDetailsSection(),
              const SizedBox(height: 30),
              const PlaceOrderButton(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildOrderSummarySection() {
    return _buildSection(
      title: 'Order Summary',
      content: _buildShoppingCartItems(),
      initiallyExpanded: true,
    );
  }

  Widget _buildPaymentOptionsSection() {
    return _buildSection(
      title: 'Payment Options',
      content: _buildPaymentOptions(),
    );
  }

  Widget _buildShippingDetailsSection() {
    return _buildSection(
      title: 'Shipping Details',
      content: _buildShippingDetails(),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    bool initiallyExpanded = false,
  }) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      initiallyExpanded: initiallyExpanded,
      children: [content],
    );
  }

  Widget _buildShoppingCartItems() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ...widget.cartItems.map((item) => CartItemWidget(model: item, readOnly: true,)),
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(
          label: 'Subtotal Amount',
          value: widget.cartDecorator.getFormattedSubtotalAmount(),
        ),
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(
          label: 'GST/HST',
          value: widget.cartDecorator.getFormattedGstAmount(),
        ),
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(
          label: 'Total Amount',
          value: widget.cartDecorator.getFormattedTotalAmount(),
          isHighlight: true,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is GetCustomerByIdLoadedState) {
          // Render UI with stored payments
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < (state.model.payments?.length ?? 0); i++)
                PaymentWidget(
                  model: state.model.payments![i],
                  isSelected: i ==
                      selectedPaymentIndex, // Check if this address is selected
                  onTap: () {
                    setState(() {
                      selectedPaymentIndex = i; // Update selected index on tap
                    });
                  },
                )
            ],
          );
        } else {
          // Render loading indicator or error message
          return const CircularProgressIndicator();
        }
      },
    );
  }

  void onAddressTap(int index) {
    setState(() {      
      selectedAddressIndex = index; // Update selected index on tap
    });
  }

  Widget _buildShippingDetails() {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is GetCustomerByIdLoadedState) {
          var addressWidgets = buildAddressWidgets(state.model.addresses ?? []);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: addressWidgets,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  List<AddressWidget> buildAddressWidgets(List<Address> addresses) {
    return [
      for (int i = 0; i < (addresses.length); i++)
        AddressWidget(
          model: addresses[i],
          isSelected: i == selectedAddressIndex,
          onTap: () {
            onAddressTap(i);
          },
        ),
    ];
  }
}

class PlaceOrderButton extends StatelessWidget {
  const PlaceOrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Add functionality for placing order
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // Set button color
              textStyle: const TextStyle(fontSize: 18), // Set text style
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(color: Colors.white), // Set text color
            ),
          ),
        ),
      ],
    );
  }
}
