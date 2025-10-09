import '/screen/auth/sign_in_controller.dart';
import '/services/customs/text_box_widegt.dart';
import '/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      init: SignInController(),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Form(
            key: controller.formKey,
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextBoxWidget(
                    controller: controller.emailController,
                    hintText: "Enter Email",
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  Obx(
                    () => TextBoxWidget(
                      controller: controller.passController,
                      obscureText: controller.isVisible.value,
                      hintText: "Enter Password",
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_open_outlined),
                      suffixIcon: IconButton(
                        onPressed: controller.checkVisibility,
                        icon: Icon(controller.isVisible.value == false ? Icons.visibility : Icons.visibility_off),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  SizedBox(height: 40),
                  AnimatedScale(
                    scale: controller.isLoading.value ? 0.96 : 1.00,
                    duration: Duration(seconds: 1),
                    child: MaterialButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              await controller.signIN();
                            },
                      color: Constants.instance.primary,
                      height: 55,
                      minWidth: double.infinity,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Constants.instance.primary),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                          : Text("Sign In", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
