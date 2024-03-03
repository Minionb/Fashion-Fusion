import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

class HomescreenAppBar extends StatelessWidget {
  final String title;

  const HomescreenAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 90.sp,
      floating: false,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              leading: const Icon(CupertinoIcons.line_horizontal_3),
              elevation: 0,
              actions: const [
                Row(
                  children: [
                    Icon(CupertinoIcons.search),
                    SizedBox(width: 10),
                    Icon(CupertinoIcons.bell),
                    SizedBox(width: 15),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
