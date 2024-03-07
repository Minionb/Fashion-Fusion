import 'package:fashion_fusion/api/end_points.dart';
import 'package:flutter/material.dart';

class ListTileImageWidget extends StatelessWidget {
  final String imageId;

  const ListTileImageWidget({super.key, required this.imageId});

  
  String _imageUrl() {
    var imageUrl =
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png';
    if (imageId.isNotEmpty) {
      imageUrl = EndPoints.getProductImagesByImageId
          .replaceAll(":imageId", imageId);
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8.0),
        bottomLeft: Radius.circular(8.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.network(
        _imageUrl(),
        width: 80,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
