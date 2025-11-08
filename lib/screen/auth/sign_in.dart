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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: constraints.maxHeight < 700 ? 16 : 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              // decoration: BoxDecoration(
                              //   gradient: LinearGradient(
                              //     colors: [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)],
                              //     begin: Alignment.topLeft,
                              //     end: Alignment.bottomRight,
                              //   ),
                              //   shape: BoxShape.circle,
                              //   boxShadow: [BoxShadow(color: Constants.instance.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                              // ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                child: Image.asset(
                                  "assets/logo.png",
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight < 700 ? 20 : 32,
                            ),

                            // Title
                            Text(
                              "Admin Portal",
                              style: GoogleFonts.poppins(
                                fontSize: constraints.maxHeight < 700 ? 26 : 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: constraints.maxHeight < 700 ? 6 : 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                "Sign in to manage coolie services",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight < 700 ? 32 : 48,
                            ),

                            // Sign In Card
                            Container(
                              padding: EdgeInsets.all(
                                constraints.maxHeight < 700 ? 20 : 28,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Email Field
                                  TextBoxWidget(
                                    controller: controller.emailController,
                                    hintText: "Enter your email",
                                    labelText: "Email Address",
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Constants.instance.primary,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight < 700
                                        ? 16
                                        : 20,
                                  ),

                                  // Password Field
                                  Obx(
                                    () => TextBoxWidget(
                                      controller: controller.passController,
                                      obscureText: controller.isVisible.value,
                                      hintText: "Enter your password",
                                      labelText: "Password",
                                      prefixIcon: Icon(
                                        Icons.lock_outline_rounded,
                                        color: Constants.instance.primary,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: controller.checkVisibility,
                                        icon: Icon(
                                          controller.isVisible.value
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight < 700
                                        ? 20
                                        : 24,
                                  ),

                                  // Sign In Button
                                  Obx(
                                    () => AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: controller.isLoading.value
                                              ? [Colors.grey, Colors.grey]
                                              : [
                                                  Constants.instance.primary,
                                                  Constants.instance.primary
                                                      .withOpacity(0.8),
                                                ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: controller.isLoading.value
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: Constants
                                                      .instance
                                                      .primary
                                                      .withOpacity(0.4),
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: controller.isLoading.value
                                              ? null
                                              : () async {
                                                  await controller.signIn();
                                                },
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: Container(
                                            height: 56,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: controller.isLoading.value
                                                ? const SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2.5,
                                                        ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Sign In",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  0.5,
                                                            ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      const Icon(
                                                        Icons
                                                            .arrow_forward_rounded,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
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
                            SizedBox(
                              height: constraints.maxHeight < 700 ? 24 : 32,
                            ),

                            // Footer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.shield_outlined,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    "Secure Admin Access",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
