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

class _DashBoardScreenState extends State<DashBoardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: _buildModernAppBar(),
          drawer: _buildModernDrawer(controller),
          body: Column(
            children: [
              _buildStatsSection(controller),
              _buildTabSection(),
              Expanded(
                child: TabBarView(controller: _tabController, children: [_buildPendingRequestsTab(controller), _buildCooliesListTab(controller)]),
              ),
            ],
          ),
          floatingActionButton: _buildModernFAB(),
        );
      },
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: Constants.instance.white, // Set your desired color here
      ),
      backgroundColor: Constants.instance.primary,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
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
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            tooltip: 'Notifications',
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(DashboardController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Constants.instance.primary,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildStatCard("Pending", controller.pendingCoolies.length.toString(), Icons.pending_actions_rounded, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard("Active Coolies", "24", Icons.people_outline_rounded, Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard("Total Bookings", "156", Icons.assignment_outlined, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard("Stations", "8", Icons.location_on_outlined, Colors.purple)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        indicator: BoxDecoration(
          gradient: LinearGradient(colors: [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)]),
          borderRadius: BorderRadius.circular(12),
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'Pending Requests'),
          Tab(text: 'Active Coolies'),
        ],
      ),
    );
  }

  Widget _buildPendingRequestsTab(DashboardController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.pendingCoolies.isEmpty) {
        return _buildEmptyState(icon: Icons.inbox_outlined, title: "No Pending Requests", subtitle: "All coolie requests are processed");
      }

      return RefreshIndicator(
        onRefresh: () => controller.pendingCoolie(),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: controller.pendingCoolies.length,
          itemBuilder: (context, index) {
            final coolie = controller.pendingCoolies[index];
            return _buildModernCoolieCard(
              coolie.name.toString(),
              coolie.mobileNo.toString(),
              coolie.buckleNumber.toString(),
              coolie.address.toString(),
              controller,
              coolie.id.toString(),
              index,
            );
          },
        ),
      );
    });
  }

  Widget _buildCooliesListTab(DashboardController controller) {
    return _buildEmptyState(icon: Icons.people_outline_rounded, title: "Active Coolies", subtitle: "Coolies list coming soon");
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildModernCoolieCard(String name, String mobile, String buckleNo, String station, DashboardController controller, String id, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _showModernBottomSheet(context, name, mobile, buckleNo, station, "Pending", id, controller);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)]),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Constants.instance.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person_rounded, size: 32, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(mobile, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.badge_outlined, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text("Buckle: $buckleNo", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange, width: 1.5),
                    ),
                    child: Text(
                      "Pending",
                      style: GoogleFonts.poppins(color: Colors.orange[800], fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernFAB() {
    return FloatingActionButton.extended(
      onPressed: () {},
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
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.admin_panel_settings_rounded, size: 40, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
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
                ListTile(
                  leading: Icon(Icons.location_on_outlined, color: Constants.instance.primary),
                  title: Text('Station Management', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Get.back();
                    // Navigate to station management
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people_outline_rounded, color: Constants.instance.primary),
                  title: Text('Admin Listing', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Get.back();
                    // Navigate to admin listing
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_outlined, color: Constants.instance.primary),
                  title: Text('Passenger Listing', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Get.back();
                    // Navigate to admin listing
                  },
                ),
                ListTile(
                  leading: Icon(Icons.approval_outlined, color: Constants.instance.primary),
                  title: Text('Coolie Approvals', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Get.back();
                    Get.toNamed(RouteName.transactionHistory);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history, color: Constants.instance.primary),
                  title: Text('Booking History', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Get.back();
                  },
                ),
                const Divider(height: 32),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Logout',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.red),
                  ),
                  onTap: () {},
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
                                  controller.approvalCoolie(id);
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
