import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skelton extends StatelessWidget {
  final double? height;
  final double? width;
  const Skelton({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade600,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(.4),
            borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
