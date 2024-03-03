import 'package:fashion_fusion/core/utils/avatar_picture.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String id;
  final String name;
  const ProfileAvatar({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: getUserAvatarNameColor(id),
      child: Text(
        name.isNotEmpty == true ? name[0].toUpperCase() : name[0].toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
