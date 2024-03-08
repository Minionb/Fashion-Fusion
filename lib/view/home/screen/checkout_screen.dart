import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/cart_decorator_utils.dart';
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/data/profile/model/profile_model.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile/profile_cubit.dart';
import 'package:fashion_fusion/view/home/widget/list_tile_product_image.dart';
import 'package:fashion_fusion/view/home/widget/total_amount_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCheckoutScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final CartDecorator cartDecorator;

  const OrderCheckoutScreen(
      {super.key, required this.cartItems, required this.cartDecorator});

  @override
  _OrderCheckoutScreenState createState() => _OrderCheckoutScreenState();
}

class _OrderCheckoutScreenState extends State<OrderCheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (context) => sl<ProfileCubit>()
            ..getProfile(sl<SharedPreferences>().getString("userID")!),
        ),
        // Add more BlocProviders as needed
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
        ...widget.cartItems.map((item) => CartItemWidget(model: item)),
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          // Render UI with stored payments
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var payment in state.model!.payments)
                PaymentWidget(model: payment)
              // Add UI elements for adding new payment options
            ],
          );
        } else {
          // Render loading indicator or error message
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildShippingDetails() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          // Render UI with stored payments
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var payment in state.model!.payments)
                PaymentWidget(model: payment)
              // Add UI elements for adding new payment options
            ],
          );
        } else {
          // Render loading indicator or error message
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItemModel model;

  const CartItemWidget({super.key, required this.model});

  Widget _productName() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          model.productName,
          maxLines: 2,
          textAlign: TextAlign.left,
          overflow: TextOverflow.fade,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Text _price() {
    var subtotal = model.price * model.quantity;
    return Text(
      "\$${fomattedPrice(subtotal)}",
      style: TextStyle(color: AppColors.textGray),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray), // Add border
          borderRadius: BorderRadius.circular(8.0), // Add border radius
        ),
        margin: const EdgeInsets.only(bottom: 16.0), // Add margin
        child: ListTile(
          leading: ListTileImageWidget(
            imageId: model.imageId,
          ),
          title: _productName(),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(model.quantity.toString()), // Quantity
                  const SizedBox(width: 16),
                  const Text('x'), // Quantity
                  const SizedBox(width: 16),
                  Text("\$${fomattedPrice(model.price)}")
                ],
              ),
              const Text("="),
              _price(),
            ],
          ),
        ));
  }

  String fomattedPrice(double price) {
    return NumberFormat("#,##0.00", "en_US").format(price);
  }
}

class PlaceOrderButton extends StatelessWidget {
  const PlaceOrderButton({Key? key});

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

class PaymentWidget extends StatelessWidget {
  final PaymentModel model;

  const PaymentWidget({super.key, required this.model});

  Widget _name() {
    return Expanded(
      child: Text(
        model.name,
        maxLines: 2,
        textAlign: TextAlign.left,
        overflow: TextOverflow.fade,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Text _exp() {
    return Text(
      model.expirationDate,
      style: TextStyle(color: AppColors.textGray),
    );
  }

  Text _card() {
    return Text(
      model.cardNumber,
      style: TextStyle(color: AppColors.textGray),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray), // Add border
          borderRadius: BorderRadius.circular(8.0), // Add border radius
        ),
        margin: const EdgeInsets.only(bottom: 16.0), // Add margin
        child: ListTile(
          title: _name(),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_card(),
            _exp()]),
        ));
  }
}

class AddressWidget extends StatelessWidget {
  final String address;

  const AddressWidget({super.key, required this.address});

  Widget _name() {
    return Expanded(
      child: Text(
        address,
        maxLines: 2,
        textAlign: TextAlign.left,
        overflow: TextOverflow.fade,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Text _exp() {
    return Text(
      address,
      style: TextStyle(color: AppColors.textGray),
    );
  }

  Text _card() {
    return Text(
      address,
      style: TextStyle(color: AppColors.textGray),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray), // Add border
          borderRadius: BorderRadius.circular(8.0), // Add border radius
        ),
        margin: const EdgeInsets.only(bottom: 16.0), // Add margin
        child: ListTile(
          title: _name(),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_card(),
            _exp()]),
        ));
  }
}
