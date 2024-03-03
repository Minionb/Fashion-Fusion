
import 'package:fashion_fusion/core/utils/avatar_picture.dart';
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
      leading: CircleAvatar(
        backgroundColor: getUserAvatarNameColor(user?.sId ?? ""),
        child: Text(
          user?.firstName?.isNotEmpty == true
              ? user!.firstName![0].toUpperCase()
              : user!.lastName![0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
