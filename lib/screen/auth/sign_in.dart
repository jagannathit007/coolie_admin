import '/screen/auth/sign_in_controller.dart';
import '/services/customs/text_box_widegt.dart';
import '/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      init: SignInController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Constants.instance.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                        ),
                        child: const Icon(Icons.admin_panel_settings_rounded, size: 64, color: Colors.white),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text(
                        "Admin Portal",
                        style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 8),
                      Text("Sign in to manage coolie services", style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[600])),
                      const SizedBox(height: 48),

                      // Sign In Card
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                        ),
                        child: Column(
                          children: [
                            // Email Field
                            TextBoxWidget(
                              controller: controller.emailController,
                              hintText: "Enter your email",
                              labelText: "Email Address",
                              prefixIcon: Icon(Icons.email_outlined, color: Constants.instance.primary),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),

                            // Password Field
                            Obx(
                              () => TextBoxWidget(
                                controller: controller.passController,
                                obscureText: controller.isVisible.value,
                                hintText: "Enter your password",
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock_outline_rounded, color: Constants.instance.primary),
                                suffixIcon: IconButton(
                                  onPressed: controller.checkVisibility,
                                  icon: Icon(controller.isVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey[600]),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            // const SizedBox(height: 12),

                            // // Forgot Password
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: TextButton(
                            //     onPressed: () {},
                            //     child: Text(
                            //       "Forgot Password?",
                            //       style: GoogleFonts.poppins(color: Constants.instance.primary, fontWeight: FontWeight.w600),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 24),

                            // Sign In Button
                            Obx(
                              () => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: controller.isLoading.value
                                        ? [Colors.grey, Colors.grey]
                                        : [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: controller.isLoading.value
                                      ? []
                                      : [BoxShadow(color: Constants.instance.primary.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: controller.isLoading.value
                                        ? null
                                        : () async {
                                            await controller.signIn();
                                          },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      height: 56,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: controller.isLoading.value
                                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Sign In",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.shield_outlined, size: 16, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 8),
                          Text("Secure Admin Access", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
