import 'package:fashion_fusion/core/widgets/profile_avatar.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.user,
  });

  final CustomerDataModel? user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${user?.firstName} ${user?.lastName}"),
      subtitle: Text(user?.email ?? ""),
      leading: ProfileAvatar(
        id: user?.sId ?? "",
        name: user?.firstName ?? "",
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
