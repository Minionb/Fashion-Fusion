import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/decorator_utils.dart';
import 'package:fashion_fusion/core/utils/order_utils.dart';
import 'package:fashion_fusion/data/order/model/order_list_model.dart';
import 'package:fashion_fusion/provider/order_cubit/order_cubit.dart';
import 'package:fashion_fusion/view/home/screen/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerOrderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCubit>(
      create: (context) => sl<OrderCubit>(),
      child: CustomerOrderListScreenContent(),
    );
  }
}

class CustomerOrderListScreenContent extends StatefulWidget {
  @override
  _CustomerOrderListScreenContentState createState() =>
      _CustomerOrderListScreenContentState();
}

class _CustomerOrderListScreenContentState
    extends State<CustomerOrderListScreenContent> {
  late OrderCubit orderCubit;

  @override
  void initState() {
    super.initState();
    _fetchOrders(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderIsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrderListLoadedState) {
            List<OrderListModel> orders = state.model;
            return RefreshIndicator(
                onRefresh: () async {
                  _fetchOrders(context);
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return OrderListElementWidget(model: orders[index]);
                        },
                      ),
                    ),
                  ],
                ));
          } else if (state is ErrorState) {
            return RefreshIndicator(
              onRefresh: () async {
                _fetchOrders(context);
              },
              child: Center(child: Text(state.message)),
            );
          } else {
            return RefreshIndicator(
                onRefresh: () async {
                  _fetchOrders(context);
                },
                child: const Center(
                  child: Text('No orders available'),
                ));
          }
        },
      ),
    );
  }

  void _fetchOrders(BuildContext context) {
    context.read<OrderCubit>().getOrdersByCustomerId();
  }
}

class OrderListElementWidget extends StatelessWidget {
  final OrderListModel model;

  const OrderListElementWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderScreen(
              orderId: model.orderId,
            ),
          ),
        )
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray), // Add border
          borderRadius: BorderRadius.circular(8.0), // Add border radius
        ),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _title("OrderId:"),
              ),
              Expanded(
                flex: 2,
                child: _title(AppFormatter.formatOrderId(model.orderId!),
                    status: model.status!),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              createKeyValRow("Order Date",
                  AppFormatter.formatDateDisplay(model.createdAt!)),
              createKeyValRow("Order Status", model.status ?? "Pending",
                  status: model.status!),
              createKeyValRow("Order Total",
                  '\$${AppFormatter.getFormattedAmount(model.totalAmount!)}'),
              _label('Items (${getItemCount()}):'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getCartItems(),
              )
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

  List<Widget> getCartItems() {
    List<Widget> productRows = [];
    for (var cartItem in model.cartItems!) {
      productRows.add(
        Row(
          children: [
            const SizedBox(width: 16.0),
            Expanded(
              flex: 3,
              child: Text(cartItem.productName ?? ""),
            ),
            const Expanded(
              flex: 1,
              child: Text('x'),
            ),
            Expanded(
              flex: 1,
              child: Text('${cartItem.quantity}'),
            ),
          ],
        ),
      );
    }
    return productRows;
  }

  Widget _title(String title, {String status = ""}) {
    Color textColor = OrderUtils.getColorBasedOnStatus(status);

    return Text(
      formatText(title),
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
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
