import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/decorator_utils.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/widgets/custom_button.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:fashion_fusion/data/order/model/admin_update_status_model.dart';
import 'package:fashion_fusion/data/order/model/order_model.dart';
import 'package:fashion_fusion/provider/order_cubit/order_cubit.dart';
import 'package:fashion_fusion/provider/order_edit_cubit/order_edit_cubit_cubit.dart';
import 'package:fashion_fusion/view/widget/cart_item_widget.dart';
import 'package:fashion_fusion/view/widget/address_card_widget.dart';
import 'package:fashion_fusion/view/widget/payment_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AdminOrderDetailsScreen extends StatefulWidget {
  String? orderId;
  late OrderModelDecorator orderDecorator;

  AdminOrderDetailsScreen({super.key, this.orderId});
  @override
  State<StatefulWidget> createState() {
    return _AdminOrderDetailsScreenState();
  }
}

class _AdminOrderDetailsScreenState extends State<AdminOrderDetailsScreen> {
  late OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderEditCubit, OrderEditState>(
      listener: (context, state) {
        if (state is OrderEditIsLoadingState) {
          context.loaderOverlay.show();
        }
        if (state is OrderEditSuccessfullyState) {
          setState(() {
            orderModel.status = state.model.order?.status;
          });
          context.loaderOverlay.hide();
        }
        if (state is OrderEditErrorState) {
          context.loaderOverlay.hide();
        }
      },
      child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderSuccessState) {
            orderModel = state.model;
            return HelperMethod.loader(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    //"Order ${AppFormatter.formatOrderId(orderModel.orderId ?? '')}",
                    "${orderModel.orderId ?? ''}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                      _buildShippingDetailsSection(),
                      20.verticalSpace,
                      (orderModel.status == "cancel" ||
                              orderModel.status == "cancelled")
                          ? const SizedBox()
                          : CustomButton(
                              label:
                                  getOrderStatusLabel(orderModel.status ?? ""),
                              bg: AppColors.primary,
                              onPressed: () {
                                updateOrderStatus(context, widget.orderId ?? "",
                                    orderModel.status);
                              },
                            ),
                      10.verticalSpace,
                      // Cancel Button
                      (orderModel.status == "cancel" ||
                              orderModel.status == "cancelled" ||
                              orderModel.status?.toLowerCase() == "delivered")
                          ? const SizedBox()
                          : CustomButton(
                              label: "Cancel",
                              bg: AppColors.primary,
                              onPressed: () {
                                updateOrderStatus(
                                    context, widget.orderId ?? "", "cancel");
                              },
                            ),
                      25.verticalSpace
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ErrorState) {
            return HelperMethod.emptyWidget(title: "Request failed.");
          } else {
            return HelperMethod.loadinWidget();
          }
        },
      ),
    );
  }

  // Function to get status label based on enum value
  String getOrderStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return "Processing";
      case "processing":
        return "Out for Delivery";
      case "out for delivery":
        return "Delivered";
      case "delivered":
        return "Order Delivered";
      case "cancel":
        return "cancel";
      default:
        return "";
    }
  }

  void updateOrderStatus(BuildContext context, String orderId, String? status) {
    if (status == null) return; // Handle null status

    String newStatus = "";

    switch (status.toLowerCase()) {
      case "pending":
        newStatus = "processing";
        break;
      case "processing":
        newStatus = "out for delivery";
        break;
      case "out for delivery":
        newStatus = "delivered";
      case "cancel":
        newStatus = "cancelled";
        break;
      case "delivered":
        // Do nothing or handle accordingly
        break;
      default:
        // Handle invalid status
        break;
    }

    if (newStatus.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext dContext) {
          return AlertDialog(
            title: const Text("Confirm Status Update"),
            content: Text(
                "Are you sure you want to update the status to '$newStatus'?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dContext).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  // Update status here
                  context.read<OrderEditCubit>().updateOrderStatus(
                        AdminOrderUpdateStatusModel(
                          orderID: orderId,
                          orderStatus: newStatus,
                        ),
                      );
                  Navigator.of(dContext).pop();
                },
                child: const Text("Confirm"),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildCartItemsSection() {
    return _buildSection(
      title: 'Items',
      content: _buildShoppingCartItems(),
      initiallyExpanded: true,
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
      children: [
        PaymentWidget(model: orderModel.payment ?? Payments(), onTap: () {})
      ],
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
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            _title("Status:"),
            const SizedBox(width: 16.0),
            _title(model.status ?? "Pending"),
            const SizedBox(width: 16.0)
          ]),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Order Date"),
                      const SizedBox(height: 16.0),
                      _label("Order Total"),
                      _label("GST/HST"),
                      _label("Subtotal"),
                      const SizedBox(height: 16.0),
                      _label("Shipping Method"),
                      _label("Courier"),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _text(AppFormatter.formatDateDisplay(model.createdAt!)),
                      const SizedBox(height: 16.0),
                      _text(
                          '\$${AppFormatter.getFormattedAmount(model.totalAmount ?? 0.0)} (${getItemCount()} items)'),
                      _text(
                          '\$${AppFormatter.getFormattedAmount(model.tax ?? 0.0)}'),
                      _text(
                          '\$${AppFormatter.getFormattedAmount(model.subtotal ?? 0.0)}'),
                      const SizedBox(height: 16.0),
                      _text(model.delivery?.method ?? "Delivery"),
                      _text(model.delivery?.courier ?? "No specified"),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getItemCount() {
    return model.cartItems!.fold<int>(
      0,
      (previousValue, element) => previousValue + element.quantity!,
    );
  }

  Widget _title(String title) {
    return Text(
      formatText(title),
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  Widget _text(String text) {
    var formattedText = formatText(text);
    return Text(
      formattedText,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      style: const TextStyle(fontWeight: FontWeight.w600),
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
