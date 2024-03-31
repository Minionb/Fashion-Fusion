import 'package:fashion_fusion/config/theme/app_theme.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile/profile_cubit.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile_edit/profile_edit_cubit.dart';
import 'package:fashion_fusion/view/home/widget/empty_list_widget.dart';
import 'package:fashion_fusion/view/profile/screen/add_edit_address_screen.dart';
import 'package:fashion_fusion/view/widget/address_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late List<Address> _addresses;

  Future<void> _fetchProfile() async {
    context
        .read<ProfileCubit>()
        .getProfile(sl<SharedPreferences>().getString("userID")!);
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
        BlocProvider<ProfileCubit>(
          create: (context) => sl<ProfileCubit>()
            ..getProfile(sl<SharedPreferences>().getString("userID")!),
        ),
        BlocProvider<ProfileEditCubit>(
          create: (context) => sl<ProfileEditCubit>(),
        ),
      ],
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
              return _buildAddressesBody();
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
    );
  }

  Widget _buildAddressesBody() {
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
                onTap: () {
                  gotoAddress(address: _addresses[i]);
                },
              ),
            _addAddressButton(),
          ],
        ),
      ),
    );
  }

  void gotoAddress({Address? address}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAddressScreen(
          address: address,
        ),
      ),
    );
  }

  Widget _addAddressButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              gotoAddress();
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
