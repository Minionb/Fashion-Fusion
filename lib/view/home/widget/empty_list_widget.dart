import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String text;

  const EmptyListWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              maxLines: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18
              ),
            ),
          ],
        ),
      ),
    );
  }
}
