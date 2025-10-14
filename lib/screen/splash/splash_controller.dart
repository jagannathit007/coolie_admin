import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/animation.dart';

import '../../routes/route_name.dart';
import '../../services/app_storage.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0, 0.8, curve: Curves.easeInOut),
      ),
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );

    animationController.forward();
_navigateHome();
  
  }


  void _navigateHome() async {
    log("Navigate Home");
    await Future.delayed(const Duration(seconds: 3));
    log("Take token from storage");
    String token = AppStorage.read("token");
    log("Token: $token");
    if (token.isNotEmpty) {
      log("Token found, navigate to Home");
      Get.offAllNamed(RouteName.home);
    } else {
      log("Token found, navigate to SignIn");
      Get.offAllNamed(RouteName.signIn);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
