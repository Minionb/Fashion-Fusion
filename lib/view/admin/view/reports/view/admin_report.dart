import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/view/admin/view/reports/widget/reports_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fashion_fusion/provider/product_cubit/product/product_cubit.dart';
import 'package:fashion_fusion/view/admin/view/reports/widget/total_income_widget.dart';

class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({super.key});

  @override
  State<AdminReportScreen> createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  late num totalIncome;

  @override
  void initState() {
    super.initState();
    totalIncome = 0;
    _fetchTotalIncome();
  }

  Future<void> _fetchTotalIncome() async {
    // Fetch initial total income
    final productCubit = context.read<ProductCubit>();
    productCubit.getProduct({
      'category': '',
      'productName': '',
    });
    productCubit.stream.listen((state) {
      if (state is ProductLoadedState) {
        final data = state.models;
        num newTotalIncome = 0;
        for (var element in data) {
          newTotalIncome += element.soldQuantity!.toDouble() * element.price!;
        }
        setState(() {
          totalIncome = newTotalIncome;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("F8F9FD"),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoadedState) {
                return TotalIncomeWidget(totalIncome: totalIncome);
              }
              return const SizedBox();
            },
          ),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadedState) {
                  final data = state.models;

                  data.sort(
                      (a, b) => b.soldQuantity!.compareTo(a.soldQuantity!));
                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<ProductCubit>().getProduct({
                      'category': '',
                      'productName': '',
                    }),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 50),
                      itemBuilder: (context, index) {
                        final model = data[index];
                        return ProductReportCard(
                          model: model,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 4),
                      itemCount: data.length,
                    ),
                  );
                }
                if (state is ProductIsLoadingState) {
                  return const CircularProgressIndicator();
                }
                if (state is ProductErrorState) {
                  return Text('Error: ${state.message}');
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
