import 'package:fashion_fusion/core/components/empty_widgte/widget.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_string.dart';
import 'package:fashion_fusion/error/failures.dart';
import 'package:flutter/material.dart';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

class HelperMethod {
  static PreferredSize appBarDivider() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(4.0),
      child: Container(
        color: AppColors.lightSeliver,
        height: 1.0,
      ),
    );
  }

  static Widget loader({required Widget child}) {
    return LoaderOverlay(
      // duration: const Duration(seconds: 50),
      // reverseDuration: Duration(minutes:2),
      closeOnBackButton: true,
      overlayColor: Colors.black.withOpacity(0.3),
      child: child,
    );
  }

  static EmptyWidget emptyWidget({String? title, String? subtitle}) {
    return EmptyWidget(
      image: "assets/images/error_widget.json",
      title: title ?? "Something went wrong",
      subTitle: subtitle,
      hideBackgroundAnimation: true,
    );
  }

  static EmptyWidget loadinWidget({String? title, String? subtitle}) {
    return EmptyWidget(
      image: "assets/images/loading_widget.json",
      title: title ?? "Loading...",
      subTitle: subtitle,
      hideBackgroundAnimation: true,
    );
  }

  static String mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppString.unexpectedError;
      case CacheFailure:
        return AppString.cacheFailure;
      default:
        return AppString.unexpectedError;
    }
  }

  static void showToast(BuildContext context,
      {ToastificationType? type, Widget? title, Widget? description}) {
    toastification.show(
      type: type,
      context: context,
      title: title,
      description: description,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}
