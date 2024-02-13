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
        // color: AppColors.erieBlack,
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
