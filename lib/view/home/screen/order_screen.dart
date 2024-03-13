import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/decorator_utils.dart';
import 'package:fashion_fusion/data/order/model/order_model.dart';
import 'package:fashion_fusion/provider/customerCubit/customer/customer_cubit.dart';
import 'package:fashion_fusion/provider/order_cubit/order_cubit.dart';
import 'package:fashion_fusion/view/widget/cart_item_widget.dart';
import 'package:fashion_fusion/view/home/widget/total_amount_widget.dart';
import 'package:fashion_fusion/view/widget/address_card_widget.dart';
import 'package:fashion_fusion/view/widget/payment_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatefulWidget {
  final OrderModel orderModel;
  late OrderModelDecorator orderDecorator;

  OrderScreen({
    super.key,
    required this.orderModel,
  });
  @override
  State<StatefulWidget> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  late OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    widget.orderDecorator = OrderModelDecorator(orderModel: widget.orderModel);
    return MultiBlocProvider(
        providers: [
          BlocProvider<OrderCubit>(
            create: (context) =>
                sl<OrderCubit>()..postOrderCheckout(widget.orderModel),
          ),
        ],
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderSuccessState) {
              orderModel = state.model;
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Order #${orderModel.orderId}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
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
                      _buildShippingDetailsSection()
                    ],
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }

  Widget _buildOrderSummarySection() {
    return _buildSection(
      title: 'Order #',
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
        ...widget.orderModel.cartItems!.map((item) => CartItemWidget(
              model: item,
              readOnly: true,
            )),
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(
          label: 'Subtotal Amount',
          value: widget.orderDecorator.getFormattedSubtotalAmount(),
        ),
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(
          label: 'GST/HST',
          value: widget.orderDecorator.getFormattedTaxAmount(),
        ),
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(
          label: 'Total Amount',
          value: widget.orderDecorator.getFormattedTotalAmount(),
          isHighlight: true,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaymentWidget(model: widget.orderModel.payment!, onTap: () {})
      ],
    );
  }

  Widget _buildShippingDetails() {
    return AddressWidget(
      model: widget.orderModel.address!,
      onTap: () {},
    );
  }
}
