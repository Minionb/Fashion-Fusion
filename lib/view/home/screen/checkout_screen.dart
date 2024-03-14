import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/decorator_utils.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:fashion_fusion/data/order/model/order_model.dart';
import 'package:fashion_fusion/provider/customerCubit/customer/customer_cubit.dart';
import 'package:fashion_fusion/view/home/screen/order_screen.dart';
import 'package:fashion_fusion/view/widget/cart_item_widget.dart';
import 'package:fashion_fusion/view/home/widget/total_amount_widget.dart';
import 'package:fashion_fusion/view/widget/address_card_widget.dart';
import 'package:fashion_fusion/view/widget/payment_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final CartDecorator cartDecorator;

  const CheckoutScreen(
      {super.key, required this.cartItems, required this.cartDecorator});

  @override
  State<StatefulWidget> createState() {
    return _CheckoutScreenState(cartItems: cartItems);
  }
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedAddressIndex = -1;
  int selectedPaymentIndex = -1;
  List<CartItemModel> cartItems;
  late List<Payments> payments;
  late List<Address> addresses;

  _CheckoutScreenState({required this.cartItems});

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
              PlaceOrderButton(onPressed: () => {checkout(context)}),
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
        ...widget.cartItems.map((item) => CartItemWidget(
              model: item,
              readOnly: true,
            )),
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(
          label: 'Subtotal Amount',
          value: widget.cartDecorator.getFormattedSubtotalAmount(),
        ),
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(
          label: 'GST/HST',
          value: widget.cartDecorator.getFormattedTaxAmount(),
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
          payments = state.model.payments ?? [];
          if (selectedPaymentIndex < 0) {
            selectedPaymentIndex = 0;
          }
          // Render UI with stored payments
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < (payments.length); i++)
                PaymentWidget(
                  model: payments[i],
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
          addresses = state.model.addresses ?? [];
          if (selectedAddressIndex < 0) {
            selectedAddressIndex = 0;
          }
          var addressWidgets = buildAddressWidgets(addresses);
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

  void checkout(BuildContext context) {
    if (selectedAddressIndex < 0 || selectedPaymentIndex < 0) {
      HelperMethod.showToast(context,
          type: ToastificationType.error,
          title: const Text('Payment and Address must be selected'));
      return;
    }
    var cartDecorator = widget.cartDecorator;
    final orderModel = OrderModel(
        cartItems: widget.cartItems,
        payment: payments[selectedPaymentIndex],
        address: addresses[selectedAddressIndex],
        delivery:
            Delivery(method: "delivery", courier: "Canada Post"), // default
        subtotal: cartDecorator.getSubTotalAmount(),
        tax: cartDecorator.getTaxAmount(),
        totalAmount: cartDecorator.getTotalAmount());

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(
          orderModel: orderModel,
        ),
      ),
    );
  }
}

class PlaceOrderButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const PlaceOrderButton({super.key, required this.onPressed});

  @override
  State<PlaceOrderButton> createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<PlaceOrderButton> {
  @override
  void initState() {
    super.initState();
    onPressed = widget.onPressed;
  }

  @override
  void didUpdateWidget(PlaceOrderButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    onPressed = widget.onPressed;
  }

  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
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
