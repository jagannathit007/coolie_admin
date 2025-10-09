import '/routes/route_name.dart';
import '/services/app_toasting.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final isVisible = true.obs;
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  signIN() async {
    isLoading.value = true;
    debugPrint("Email: '${emailController.text.trim()}'");
    debugPrint("Password: '${passController.text.trim()}'");
    // if(!_validateForm()) return;
    try {
      if (emailController.text.trim() == "admin@gmail.com" && passController.text.trim() == "123456") {
        Get.toNamed(RouteName.travelHomeScreen);
        AppToasting.showSuccess("Success");
      } else {
        AppToasting.showError("Failed");
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("");
    } finally {
      isLoading.value = false;
    }
  }

  void checkVisibility() {
    isVisible.value = !isVisible.value;
  }

  bool _validateForm() {
    if (passController.text.isEmpty || !emailController.text.isEmail) {
      AppToasting.showWarning('Please enter a valid email');
      return false;
    }
    if (passController.text.isEmpty || passController.text.length < 6) {
      AppToasting.showWarning('Password must be at least 6 characters');
      return false;
    }
    return true;
  }
}
