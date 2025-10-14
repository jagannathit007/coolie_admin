import 'dart:convert';

import '../../repositories/authentication_repo.dart';
import '../../services/app_storage.dart';
import '/routes/route_name.dart';
import '/services/app_toasting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final isVisible = true.obs;
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final AuthenticationRepo _authRepo = AuthenticationRepo();

  @override
  void onInit() {
    super.onInit();
    _authRepo.init();
  }

  Future<void> signIn() async {
    if (!_validateForm()) return;

    isLoading.value = true;
    try {
      final response = await _authRepo.signIn(
        email: emailController.text.trim(),
        password: passController.text.trim(),
        deviceId: "device-id-placeholder",
        fcm: "fcm-token-placeholder",
      );

      if (response != null && response.token != null && response.admin != null) {
        debugPrint("Sign-in successful: Token=${response.token}, Admin=${response.admin?.name}");
        final adminModel = response.admin!;
        await AppStorage.write('token', response.token);
        await AppStorage.write('admin', json.encode(adminModel.toJson()));
        Get.toNamed(RouteName.home);
        AppToasting.showSuccess("Admin logged in successfully");
      } else {
        AppToasting.showError("Invalid email or password");
      }
    } catch (e) {
      debugPrint("Sign-in error: $e");
      AppToasting.showError("Failed to sign in. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void checkVisibility() {
    isVisible.value = !isVisible.value;
  }

  bool _validateForm() {
    if (emailController.text.trim().isEmpty || !GetUtils.isEmail(emailController.text.trim())) {
      AppToasting.showWarning('Please enter a valid email');
      return false;
    }
    if (passController.text.trim().isEmpty || passController.text.trim().length < 6) {
      AppToasting.showWarning('Password must be at least 6 characters');
      return false;
    }
    return formKey.currentState?.validate() ?? false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passController.dispose();
    super.onClose();
  }
}