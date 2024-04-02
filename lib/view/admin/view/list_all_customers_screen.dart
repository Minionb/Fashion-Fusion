import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';
import 'package:fashion_fusion/provider/customerCubit/customer/customer_cubit.dart';
import 'package:fashion_fusion/view/admin/widget/admin_app_drawer.dart';
import 'package:fashion_fusion/view/admin/widget/customer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListAllCustomersScreen extends StatefulWidget {
  const ListAllCustomersScreen({super.key});

  @override
  State<ListAllCustomersScreen> createState() => _ListAllCustomersScreenState();
}

class _ListAllCustomersScreenState extends State<ListAllCustomersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(sl<SharedPreferences>().getString("token"));
    _fetchCustomers(context.read<CustomerCubit>());
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  String firstName = '';
  String lastName = '';


  Map<String, String> customerQueryParams = {
    'first_name': '',
    'last_name': '',
  };


  Future<void> _fetchCustomers(CustomerCubit customerCubit) async {
    setState(() {
      customerCubit.getCustomer(customerQueryParams);
    });
  }

  void handleSearchButtonTap() {
      setState(() {
        if (firstNameController.text != "") {
          firstName = "${firstNameController.text}*";
        } else {
          firstName = "";
        }
        if (lastNameController.text != "") {
          lastName = "${lastNameController.text}*";
        } else {
          lastName = "";
        }

        customerQueryParams = {
          'first_name': firstName,
          'last_name': lastName,
        };
        _fetchCustomers(context.read<CustomerCubit>());
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const AppDrawer(),
      ),
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        bottom: HelperMethod.appBarDivider(),
        title: const Text("Users"),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'First Name',
                      ),
                  onChanged: (value) {
                    debugPrint("value on Change");
                    setState(() {
                      handleSearchButtonTap();
                    });
                    },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Last Name',
                      ),
                    onChanged: (value) {
                      debugPrint("value on Change");
                      setState(() {
                        handleSearchButtonTap();
                      });
                    },
                    ),
                  ),
                ),
              ]
            )
          ),
      Expanded(
        child: BlocBuilder<CustomerCubit, CustomerState>(
        builder: (context, state) {
          if (state is CustomerIsLoadingState) {
            return HelperMethod.loadinWidget();
          }
          if (state is CustomerLoadedState) {
            //final mdoel = state.model;
            return RefreshIndicator(
                onRefresh: () async {
                  context.read<CustomerCubit>().getCustomer(customerQueryParams);
                },
                child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 15, 12, 50).w,
                itemBuilder: (context, index) {
                    return BlocProvider(
                        create: (context) => sl<CustomerCubit>(),
                        child: CustomerCard(user: state.models[index]),
                      );
                    },
                    separatorBuilder: (context, index) => 10.verticalSpace,
                    itemCount: state.models.length),

                
                //   final user = state.models[index];
                //   return CustomerCard(user: user);
                // },
                // separatorBuilder: (context, index) => const Divider(),
                // itemCount: state.models.length ?? 0
                );

          }
          if (state is CustomerErrorState) {
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
}
