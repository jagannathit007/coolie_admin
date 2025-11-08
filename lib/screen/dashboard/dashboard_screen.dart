import 'package:coolie_admin/screen/dashboard/addCoolieBottomSheet.dart';

import '../../services/app_storage.dart';
import '../../services/app_toasting.dart';
import 'dashboard_controller.dart';
import '/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/route_name.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildModernAppBar(),
          // drawer: _buildModernDrawer(controller),
          body: Column(
            children: [
              _buildStatsSection(controller),
              _buildActionButtonsSection(),
            ],
          ),
          // floatingActionButton: _buildModernFAB(),
        );
      },
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(
        color: Constants.instance.white, // Set your desired color here
      ),
      backgroundColor: Constants.instance.primary,
      elevation: 0,
      title: Row(
        children: [
          // Container(
          //   padding: const EdgeInsets.all(8),
          //   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          //   child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 24),
          // ),
          // const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Admin Portal",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text("Dashboard", style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
            ],
          ),
          
        ],
      ),
      actions: [
        // Container(
        //   margin: const EdgeInsets.only(right: 8),
        //   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.notifications_outlined, color: Colors.white),
        //     tooltip: 'Notifications',
        //   ),
        // ),
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {
              _showLogoutDialog();
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.red[700]!],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () async {
                Get.back();
                await _logout();
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _logout() async {
    try {
      await AppStorage.clearAll();
      AppToasting.showSuccess('Logged out successfully!');
      Get.offAllNamed(RouteName.signIn);
    } catch (e) {
      debugPrint("Logout error: ${e.toString()}");
      AppToasting.showError('Logout failed: ${e.toString()}');
    }
  }


  Widget _buildStatsSection(DashboardController controller) {
    return Obx(
      () {
        final stats = controller.dashboardStats.value;
        
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildStatCard("Total Passengers", stats?.overview.totalUsers.total ?? "0", Icons.people_outline_rounded, Colors.orange)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard("Total Coolies", stats?.overview.activeCollies.total ?? "0", Icons.people_outline_rounded, Colors.green)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildStatCard("Total Bookings", stats?.overview.totalBookings.count ?? "0", Icons.assignment_outlined, Colors.blue)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard("Stations", stats?.overview.totalStations ?? "0", Icons.location_on_outlined, Colors.purple)),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsSection() {
    return Padding( // CHANGED: Removed Expanded widget
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // CHANGED: from center to start
        children: [
          const SizedBox(height: 20), // You can reduce this if you want even less space
          _buildProfessionalButton(
            title: "Stations",
            subtitle: "Manage and view all stations",
            icon: Icons.business_outlined,
            color: Constants.instance.primary.withOpacity(0.6),
            onTap: () {
              // Navigate to passengers screen
              Get.toNamed(RouteName.station);
              // Get.snackbar(
              //   "Passengers",
              //   "Passengers screen coming soon",
              //   snackPosition: SnackPosition.BOTTOM,
              //   backgroundColor: Colors.white,
              //   colorText: Colors.black87,
              // );
            },
          ),
          const SizedBox(height: 20),
          _buildProfessionalButton(
            title: "Coolies",
            subtitle: "Manage and view all coolies",
            icon: Icons.people_outline_rounded,
            color: Constants.instance.primary.withOpacity(0.6),
            onTap: () {
              // Navigate to coolies screen
              Get.toNamed(RouteName.coolieScreen);
              // Get.snackbar(
              //   "Coolies",
              //   "Coolies screen coming soon",
              //   snackPosition: SnackPosition.BOTTOM,
              //   backgroundColor: Colors.white,
              //   colorText: Colors.black87,
              // );
            },
          ),
          const SizedBox(height: 20),
          _buildProfessionalButton(
            title: "Passengers",
            subtitle: "Manage and view all passengers",
            icon: Icons.person_outline_rounded,
            color: Constants.instance.primary.withOpacity(0.6),
            onTap: () {
              // Navigate to passengers screen
              Get.toNamed(RouteName.passengerScreen);
              // Get.snackbar(
              //   "Passengers",
              //   "Passengers screen coming soon",
              //   snackPosition: SnackPosition.BOTTOM,
              //   backgroundColor: Colors.white,
              //   colorText: Colors.black87,
              // );
            },
          ),
        ],
      ),
    );
  }
  Widget _buildProfessionalButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showAddCoolieBottomSheet(context);
      },
      backgroundColor: Constants.instance.primary,
      elevation: 6,
      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
      label: Text(
        "Add Coolie",
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  Widget _buildModernDrawer(DashboardController controller) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   padding: const EdgeInsets.all(4),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     shape: BoxShape.circle,
                //     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                //   ),
                //   child: const CircleAvatar(
                //     radius: 36,
                //     backgroundColor: Colors.white,
                //     child: Icon(Icons.admin_panel_settings_rounded, size: 40, color: Colors.grey),
                //   ),
                // ),
                // const SizedBox(height: 16),
                Text(
                  "Admin",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text("admin@gmail.com", style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // ListTile(
                //   leading: Icon(Icons.location_on_outlined, color: Constants.instance.primary),
                //   title: Text('Station Management', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                //   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                //   onTap: () {
                //     Get.back();
                //     // Navigate to station management
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.people_outline_rounded, color: Constants.instance.primary),
                //   title: Text('Admin Listing', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                //   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                //   onTap: () {
                //     Get.back();
                //     // Navigate to admin listing
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.person_outlined, color: Constants.instance.primary),
                //   title: Text('Passenger Listing', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                //   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                //   onTap: () {
                //     Get.back();
                //     // Navigate to admin listing
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.approval_outlined, color: Constants.instance.primary),
                //   title: Text('Coolie Approvals', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                //   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                //   onTap: () {
                //     Get.back();
                //     Get.toNamed(RouteName.transactionHistory);
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.history, color: Constants.instance.primary),
                //   title: Text('Booking History', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                //   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                //   onTap: () {
                //     Get.back();
                //   },
                // ),
                // const Divider(height: 32),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Logout',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.red),
                  ),
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                          TextButton(
                            onPressed: () async {
                              Get.back();
                              await controller.logout();
                            },
                            child: const Text('Logout', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showModernBottomSheet(
  BuildContext context,
  String name,
  String mobile,
  String buckleNo,
  String station,
  String status,
  String id,
  DashboardController controller,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, -4))],
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(0),
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Constants.instance.primary.withOpacity(0.1), Constants.instance.primary.withOpacity(0.05)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))],
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.blue[50],
                                child: Icon(Icons.person_rounded, size: 36, color: Constants.instance.primary),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(mobile, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            _buildDetailRow(Icons.badge_outlined, "Buckle Number", buckleNo),
                            const Divider(height: 32),
                            _buildDetailRow(Icons.location_on_outlined, "Station", station),
                            const Divider(height: 32),
                            _buildDetailRow(Icons.check_circle_outline, "Status", status, valueColor: status == "Pending" ? Colors.orange : Colors.green),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[300]!),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.poppins(color: Colors.grey[700], fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.green, const Color(0xFF43A047)]),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  controller.approveCoolie();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Approve",
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildDetailRow(IconData icon, String label, String value, {Color valueColor = Colors.black87}) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Constants.instance.primary, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
        ),
      ),
      Text(
        value,
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: valueColor),
      ),
    ],
  );
}

void _showAddCoolieBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const AddCoolieBottomSheet();
    },
  );
}
