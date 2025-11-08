import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_constants.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Constants.instance.white, Constants.instance.primary.withOpacity(0.8)],
              ),
            ),
            child: Stack(
              children: [
                // Decorative circles in background
                Positioned(
                  top: -100,
                  right: -100,
                  child: AnimatedBuilder(
                    animation: controller.animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: 0.1 * controller.fadeAnimation.value,
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: -50,
                  child: AnimatedBuilder(
                    animation: controller.animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: 0.1 * controller.fadeAnimation.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        ),
                      );
                    },
                  ),
                ),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated logo with circular background
                      AnimatedBuilder(
                        animation: controller.animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: controller.scaleAnimation.value,
                            child: Transform.rotate(
                              angle: (1 - controller.scaleAnimation.value) * 0.5,
                              child: Opacity(
                                opacity: controller.fadeAnimation.value,
                                child: Container(
                                  // width: 140,
                                  // height: 140,
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  //   shape: BoxShape.circle,
                                  //   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, spreadRadius: 5, offset: const Offset(0, 10))],
                                  // ),
                                  child: Center(child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                child: Image.asset(
                                  "assets/logo.png",
                                  width: 120,
                                  height: 120,
                                ),
                              ),),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // App name with animation
                      AnimatedBuilder(
                        animation: controller.animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: controller.fadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - controller.fadeAnimation.value)),
                              child: Column(
                                children: [
                                  Text(
                                    'Coolie Admin',
                                    style: GoogleFonts.poppins(
                                      fontSize: 38,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      shadows: [Shadow(color: Colors.black.withOpacity(0.2), offset: const Offset(0, 4), blurRadius: 8)],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                                    ),
                                    child: Text(
                                      'Service Management',
                                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Tagline with animation
                      AnimatedBuilder(
                        animation: controller.animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: controller.fadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - controller.fadeAnimation.value)),
                              child: Text(
                                'Your Trusted Porter Partner',
                                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white.withOpacity(0.9), letterSpacing: 0.5, fontWeight: FontWeight.w400),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Animated progress indicator with modern design
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: controller.animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: controller.fadeAnimation.value,
                          child: Column(
                            children: [
                              Text(
                                'Loading...',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500, letterSpacing: 1),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 200,
                                height: 4,
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.transparent,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                    minHeight: 4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Version info at bottom
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: controller.animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: controller.fadeAnimation.value * 0.6,
                          child: Text('Version 1.0.0', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white.withOpacity(0.7), letterSpacing: 0.5)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
