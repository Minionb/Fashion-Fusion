import 'package:fashion_fusion/core/utils/app_images.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/decorator_utils.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/provider/order_cubit/order_cubit.dart';
import 'package:fashion_fusion/provider/order_edit_cubit/order_edit_cubit_cubit.dart';
import 'package:fashion_fusion/view/admin/view/admin_order/screen/admin_order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {

  // Map<String, mongo.ObjectId> orderQueryParams = {
  //   'orderId':mongo.ObjectId(),
  // };

    Map<String, String> orderQueryParams = {
    'orderId': "",
  };

  TextEditingController searchController = TextEditingController();

    void handleSearchButtonTap() {
    setState(() {
      if (searchController.text != "") {
        // mongo.ObjectId orderId = mongo.ObjectId.parse(searchController.text);
        String orderId = searchController.text;
        orderQueryParams = {
          'orderId': orderId,
        };
      } else {
        orderQueryParams = {
          'orderId': "",
        };
      }
      print(orderQueryParams);
      context.read<OrderCubit>().adminGetORders(orderQueryParams);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: Column(
        children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Orders by Order ID',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  handleSearchButtonTap();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderIsLoadingState) {
            return HelperMethod.loadinWidget();
          }
          if (state is OrderAdminLoadedState) {
            final data = state.model
                .where((element) =>
                    element.status?.toLowerCase() != "cancel" &&
                    element.status?.toLowerCase() != "cancelled")
                .toList();
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<OrderCubit>().adminGetORders(orderQueryParams),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final model = data[index];
                  Color statusColor = Colors.transparent; // Default color
                  switch (model.status?.toLowerCase()) {
                    case "pending":
                      statusColor =
                          Colors.orange; // Change color for pending status
                      break;
                    case "processing":
                      statusColor =
                          Colors.blue; // Change color for processing status
                      break;
                    case "out for delivery":
                      statusColor = Colors
                          .green; // Change color for out for delivery status
                      break;
                    case "delivered":
                      statusColor =
                          Colors.grey; // Change color for delivered status
                      break;
                    case "cancelled": // Add case for cancelled status
                    case "cancel": // Add case for cancelled status
                      statusColor =
                          Colors.red; // Set color for cancelled status
                      break;
                    default:
                      statusColor =
                          Colors.transparent; // Change color for other statuses
                      break;
                  }
                  return ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => sl<OrderCubit>()
                                  ..getOrderId(model.orderId ?? ""),
                              ),
                              BlocProvider(
                                create: (context) => sl<OrderEditCubit>(),
                              ),
                            ],
                            child: AdminOrderDetailsScreen(
                              orderId: model.orderId,
                            ),
                          );
                        },
                      )).then((value) {
                        context.read<OrderCubit>().adminGetORders(orderQueryParams);
                      });
                    },
                    dense: true,
                    // title: Text("ID:${model.orderId?.substring(0, 10) ?? ""}"),
                    title: Expanded(
                        child:Text("ID:${model.orderId ?? ""}", 
                        overflow: TextOverflow.ellipsis,)
                        ),
                    leading: SizedBox(
                        width: 35,
                        height: 35, 
                        child:Image.asset(AppImages.package)
                        ),
                    subtitle: Text("\$${AppFormatter.getFormattedAmount(model.totalAmount ?? 0.0)}"),
                    trailing: Container(
                      padding: const EdgeInsets.all(4).w,
                      decoration: BoxDecoration(
                        color: statusColor, // Set color dynamically
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        getOrderStatusLabel(model.status ?? ""),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: data.length,
              ),
            );
          }
          if (state is ErrorState) {
            return HelperMethod.emptyWidget();
          }
          return const SizedBox();
        },
      ),
    )
   ]
  )
  );
  }

  String getOrderStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return "Pending";
      case "processing":
        return "Processing";
      case "out for delivery":
        return "Out for delivery";
      case "delivered":
        return "Delivered";
      case "cancelled":
      case "cancel":
        return "Cancelled";
      default:
        return "";
    }
  }
}
