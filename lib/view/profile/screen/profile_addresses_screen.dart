import 'package:fashion_fusion/config/theme/app_theme.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:fashion_fusion/data/profile/model/upload_profile_model.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile/profile_cubit.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile_edit/profile_edit_cubit.dart';
import 'package:fashion_fusion/view/home/widget/empty_list_widget.dart';
import 'package:fashion_fusion/view/profile/screen/add_address_screen.dart';
import 'package:fashion_fusion/view/widget/address_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late List<Address> _addresses;

  Future<void> _fetchProfile() async {
    setState(() {
      context
          .read<ProfileCubit>()
          .getProfile(sl<SharedPreferences>().getString("userID")!);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ProfileEditCubit>(
            create: (context) => sl<ProfileEditCubit>(),
          ),
        ],
        child: BlocListener<ProfileEditCubit, ProfileEditState>(
          listener: (context, state) {
            if (state is ProfileEditSuccessState) {
              HelperMethod.showToast(context,
                  type: ToastificationType.success,
                  title: const Text('Profile updated successfully'));
              _fetchProfile();
            } else if (state is ProfileEditErrorState) {
              HelperMethod.showToast(context,
                  type: ToastificationType.success,
                  title: const Text('Failed to update profile. Please try again.'));
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Addresses",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            body: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileIsLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ProfileLoadedState) {
                  _addresses = state.model!.addresses;
                  return _buildAddressesBody(context);
                } else if (state is ProfileErrorState) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      _fetchProfile();
                    },
                    child: const Center(
                      child: EmptyListWidget(
                        text: 'Failed to get addresses. Try again later.',
                      ),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      _fetchProfile();
                    },
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }

  Widget _buildAddressesBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchProfile();
      },
      child: AnimationLimiter(
        child: ListView(
          padding: const EdgeInsets.all(16.0), // Add padding
          children: [
            for (int i = 0; i < _addresses.length; i++)
              AddressWidget(
                model: _addresses[i],
                readOnly: _addresses.length <=
                    1, // don't allow delete if there's only 1 address
                onDelete: (deletedAddress) {
                  deleteAddress(context, deletedAddress);
                },
              ),
            _addAddressButton(context),
          ],
        ),
      ),
    );
  }

  void gotoAddress(BuildContext thisScreenContext) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
            create: (context) => sl<ProfileEditCubit>(),
            child: (AddAddressScreen(
              addressList: _addresses,
              onAddressSave: (newAddress) =>
                  {saveNewAddress(thisScreenContext, newAddress)},
            ))),
      ),
    );
  }

  // Delete an address from _addresses
  void deleteAddress(BuildContext context, Address address) {
    List<Address> newAddressList = List.from(_addresses);
    newAddressList.remove(address);
    updatedAddresses(newAddressList, context);
  }

  void saveNewAddress(BuildContext context, Address address) {
    List<Address> newAddressList = List.from(_addresses);
    newAddressList.add(address);
    updatedAddresses(newAddressList, context);
  }

  void updatedAddresses(List<Address> newAddressList, BuildContext context) {
    List<Map<String, dynamic>> jsonListAddresses =
        newAddressList.map((e) => e.toJson()).toList();
    context.read<ProfileEditCubit>().updateProfile(
        UploadProfileModel(dictionary: 'addresses', newData: jsonListAddresses),
        sl<SharedPreferences>().getString("userID")!);
  }

  Widget _addAddressButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              gotoAddress(context);
            },
            style: AppTheme.primaryButtonStyle(),
            child: const Text(
              'Add address',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
