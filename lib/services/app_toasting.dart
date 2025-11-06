import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AppToasting {
  AppToasting._();

  // Success Toast
  static void showSuccess(String message) {
    _showMaterialSnackBar(message: message, backgroundColor: Color.fromRGBO(72, 215, 97, 1), icon: Icons.check_circle);
  }

  // Error Toast
  static void showError(String message) {
    _showMaterialSnackBar(message: message, backgroundColor: Color.fromRGBO(255, 52, 91, 1), icon: Icons.error);
  }

  // Warning Toast
  static void showWarning(String message) {
    _showMaterialSnackBar(message: message, backgroundColor: Color.fromARGB(255, 130, 92, 4), icon: Icons.warning);
  }

  // GreyColor Toast
  static void showGrey(String message) {
    _showMaterialSnackBar(message: message, backgroundColor: Color.fromRGBO(45, 135, 232, 1), icon: Icons.info);
  }

  static void _showMaterialSnackBar({required String message, required Color backgroundColor, IconData? icon}) {
    // Close any currently open keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    // Use post-frame callback to ensure we're not in build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackBarAfterBuild(message: message, backgroundColor: backgroundColor, icon: icon);
    });
  }

  static void _showSnackBarAfterBuild({required String message, required Color backgroundColor, IconData? icon}) {
    if (Get.context != null && Get.context!.mounted) {
      ScaffoldMessenger.of(Get.context!).clearSnackBars();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (icon != null) Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 10),
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } else {
      _fallbackToFlutterToast(message, backgroundColor);
    }
  }

  static void _fallbackToFlutterToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

errorToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 12.0,
  );
}

successToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 12.0,
  );
}

warningToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.amber,
    textColor: Colors.black,
    fontSize: 12.0,
  );
}
