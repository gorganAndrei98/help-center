import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { Error, Normal, Success }
class UITemplates {
  static void showToast(String text, ToastType type) {

    Color bgColor;
    switch (type) {
      case ToastType.Error:
        bgColor = Colors.red;
        break;

      case ToastType.Success:
        bgColor = Colors.green;
        break;

      case ToastType.Normal:
      default:
        bgColor = Colors.grey;
        break;
    }

    final isError = type == ToastType.Error;
    Fluttertoast.showToast(
      msg: text,
      toastLength: isError ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      timeInSecForIosWeb: isError ? 6 : 2,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
    );
  }
}