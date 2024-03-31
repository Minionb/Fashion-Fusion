import 'package:fashion_fusion/config/theme/app_theme.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/decorator_utils.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/utils/order_utils.dart';
import 'package:fashion_fusion/data/order/model/order_model.dart';
import 'package:fashion_fusion/provider/order_cubit/order_cubit.dart';
import 'package:fashion_fusion/view/widget/cart_item_widget.dart';
import 'package:fashion_fusion/view/widget/address_card_widget.dart';
import 'package:fashion_fusion/view/widget/payment_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatefulWidget {
  OrderModel? orderModel;
  String? orderId;
  late OrderModelDecorator orderDecorator;

  OrderScreen({super.key, this.orderModel, this.orderId});
  @override
  State<StatefulWidget> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  late OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<OrderCubit>(create: (context) {
            if (widget.orderModel != null) {
              widget.orderDecorator =
                  OrderModelDecorator(orderModel: widget.orderModel!);
              return sl<OrderCubit>()..postOrderCheckout(widget.orderModel!);
            } else if (widget.orderId != null) {
              return sl<OrderCubit>()..getOrderId(widget.orderId!);
            } else {
              return sl<OrderCubit>();
            }
          }),
        ],
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderSuccessState) {
              orderModel = state.model;
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Order ${AppFormatter.formatOrderId(orderModel.orderId ?? '')}",
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
                      _buildCartItemsSection(),
                      _buildPaymentOptionsSection(),
                      _buildShippingDetailsSection()
                    ],
                  ),
                ),
              );
            } else if (state is ErrorState) {
              return HelperMethod.emptyWidget(title: "Request failed.");
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }

  Widget _buildCartItemsSection() {
    return _buildSection(
      title: 'Items',
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

  Widget _buildOrderSummarySection() {
    return _buildSection(
      title: 'Order Summary',
      initiallyExpanded: true,
      content: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          OrderSummaryWidget(
            model: orderModel,
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingCartItems() {
    var list = orderModel.cartItems ?? [];
    var children = [
      ...list.map((item) => CartItemWidget(
            model: item,
            readOnly: true,
          )),
    ];
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [PaymentWidget(model: orderModel.payment!, onTap: () {})],
    );
  }

  Widget _buildShippingDetails() {
    return AddressWidget(
      model: orderModel.address!,
      onTap: () {},
    );
  }
}

class OrderSummaryWidget extends StatelessWidget {
  final OrderModel model;

  const OrderSummaryWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    String status = model.status ?? "";
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          title: _buildTitleRow("Status", status, status: status),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              createKeyValRow("Order Date",
                  AppFormatter.formatDateDisplay(model.createdAt!)),
              const SizedBox(height: 16.0),
              createKeyValRow("Order Total",
                  '\$${AppFormatter.getFormattedAmount(model.totalAmount ?? 0.0)} (${getItemCount()} items)'),
              createKeyValRow("GST/HST",
                  '\$${AppFormatter.getFormattedAmount(model.tax ?? 0.0)}'),
              createKeyValRow("Subtotal",
                  '\$${AppFormatter.getFormattedAmount(model.subtotal ?? 0.0)}'),
              const SizedBox(height: 16.0),
              createKeyValRow(
                  "Shipping Method", model.delivery?.method ?? "Delivery"),
              createKeyValRow(
                  "Courier", model.delivery?.courier ?? "Not specified"),
              const SizedBox(height: 16.0),
              _cancelOrderButton()
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTitleRow(String label, String val, {String status = ""}){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _label(label),
        ),
        Expanded(
          flex: 2,
          child: _text(val, status: status),
        ),
      ],
    );
  }

  Row createKeyValRow(String label, String val, {String status = ""}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _label(label),
        ),
        Expanded(
          flex: 2,
          child: _text(val, status: status),
        ),
      ],
    );
  }

  Widget _cancelOrderButton() {
    bool ifOrderIsProcessing = model.status == 'pending';
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: !ifOrderIsProcessing
                ? AppTheme.disabledButtonStyle()
                : AppTheme.primaryButtonStyle(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  int getItemCount() {
    return model.cartItems!.fold<int>(
      0,
      (previousValue, element) => previousValue + element.quantity!,
    );
  }

  Widget _title(String title, {String status = ""}) {
    Color textColor = OrderUtils.getColorBasedOnStatus(status);
    return Text(
      formatText(title),
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
    );
  }

  Widget _text(String text, {String status = ""}) {
    var formattedText = formatText(text);
    return Text(
      formattedText,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          color: OrderUtils.getColorBasedOnStatus(status)),
    );
  }

  Widget _label(String text) {
    var formattedText = formatText(text);
    return Text(
      formattedText,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
    );
  }

  String formatText(String text) {
    String formattedText = '';
    if (text.isNotEmpty) {
      var firstLetter = text[0];
      formattedText = firstLetter.toUpperCase() + text.substring(1);
    } else {
      formattedText = '';
    }
    return formattedText;
  }
}
