import '/screen/dashboard/dashboard/dashboard_controller.dart';
import '/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/route_name.dart';

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
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Constants.instance.primary,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Admin@gmail.com", style: GoogleFonts.poppins(fontSize: 15)),
                Text("admin", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
            centerTitle: false,
            leading: CircleAvatar(radius: 30, backgroundColor: Colors.red, child: Icon(Icons.person)),
            actions: [
              IconButton(
                onPressed: () {},
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  foregroundColor: WidgetStatePropertyAll(Constants.instance.white),
                  backgroundColor: WidgetStatePropertyAll(Constants.instance.white),
                ),
                icon: Icon(Icons.logout, color: Constants.instance.primary),
                tooltip: 'Logout',
              ),
              const SizedBox(width: 16),
            ],
          ),

          // drawer:  Obx(() {
          //   // final profile = controller.userProfile.value;
          //   // return Drawer(
          //   //   child: Column(
          //   //     children: [
          //   //       UserAccountsDrawerHeader(
          //   //         accountName: Text(
          //   //           // profile?.name ?? "Loading...",
          //   //           "Admin",
          //   //           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          //   //         ),
          //   //         accountEmail: Text(
          //   //           // profile?.emailId.isNotEmpty == true
          //   //           //     ? profile!.emailId
          //   //           //     : profile?.mobileNo ?? "",
          //   //           "123456789",
          //   //           style: GoogleFonts.poppins(),
          //   //         ),
          //   //         currentAccountPicture: CircleAvatar(
          //   //           backgroundColor: Colors.white,
          //   //           // child: profile?.image?.url.isNotEmpty == true
          //   //           //     ? ClipOval(
          //   //           //   child: Image.network(
          //   //           //     "profile!.image!.url",
          //   //           //     fit: BoxFit.cover,
          //   //           //     width: 70,
          //   //           //     height: 70,
          //   //           //   ),
          //   //           // )
          //   //            child : const Icon(Icons.person, size: 40, color: Colors.grey),
          //   //         ),
          //   //         decoration: BoxDecoration(color: Constants.instance.primary),
          //   //       ),
          //   //
          //   //       Expanded(
          //   //         child: ListView(
          //   //           padding: EdgeInsets.zero,
          //   //           children: [
          //   //             ListTile(
          //   //               leading: const Icon(Icons.dashboard_outlined),
          //   //               title: Text('Dashboard', style: GoogleFonts.poppins()),
          //   //               onTap: () => Get.back(),
          //   //             ),
          //   //             ListTile(
          //   //               leading: const Icon(Icons.history),
          //   //               title: Text("Coolie Approval",
          //   //                   style: GoogleFonts.poppins()),
          //   //               onTap: () {
          //   //                 Get.back();
          //   //                 Get.toNamed(RouteName.transactionHistory);
          //   //               },
          //   //             ),
          //   //             ListTile(
          //   //               leading: const Icon(Icons.history),
          //   //               title: Text("Booking History",
          //   //                   style: GoogleFonts.poppins()),
          //   //               onTap: () {
          //   //                 Get.back();
          //   //                 // Get.to(()=> BookingHistory());
          //   //               },
          //   //             ),
          //   //             const Divider(),
          //   //             ListTile(
          //   //               leading: const Icon(Icons.logout),
          //   //               title: Text('Logout', style: GoogleFonts.poppins()),
          //   //               // onTap: () => controller.showLogoutDialog(),
          //   //             ),
          //   //           ],
          //   //         ),
          //   //       ),
          //   //     ],
          //   //   ),
          //   // );
          // }),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Constants.instance.primary,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Constants.instance.primary,
                labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: 'Pending Request'),
                  Tab(text: 'Coolies'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Obx(() {
                      if (controller.pendingCoolies.isEmpty) {
                        return const Center(child: Text("No pending requests"));
                      }
                      return ListView.builder(
                        itemCount: controller.pendingCoolies.length,
                        itemBuilder: (context, index) {
                          final coolie = controller.pendingCoolies[index];
                          return _pendingCoolieCard(
                            coolie.name.toString(),
                            coolie.mobileNo.toString(),
                            coolie.buckleNumber.toString(),
                            coolie.address.toString(),
                            controller,
                            coolie.id.toString(),
                          );
                        },
                      );
                    }),

                    Center(child: Text("Coolies List Coming Soon...", style: GoogleFonts.poppins(fontSize: 16))),
                  ],
                ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: Text("ADD COOLIE", style: GoogleFonts.poppins(fontSize: 16)),
          ),
        );
      },
    );
  }
}

Widget _pendingCoolieCard(String name, String mobile, String buckleNo, String station, DashboardController controller, String id) {
  return Padding(
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: GestureDetector(
      onTap: () {
        _showBookingDetailsBottomSheet(Get.context!, name, mobile, buckleNo, station, "Pending", id, controller);
      },
      child: Card(
        elevation: 0,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Constants.instance.secondary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          child: Row(
            children: [
              const CircleAvatar(radius: 35, child: Icon(Icons.person)),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name), Text(mobile), Text(buckleNo), Text(station)]),
            ],
          ),
        ),
      ),
    ),
  );
}

void _showBookingDetailsBottomSheet(
  BuildContext context,
  String name,
  String mobile,
  String buckleNo,
  String station,
  String status,
  String id,
  DashboardController Dcontroller,
) {
  debugPrint("IDDD $id");
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.45,
        maxChildSize: 0.6,
        minChildSize: 0.3,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, -4))],
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.blue[50],
                      child: Icon(Icons.person, size: 38, color: Constants.instance.grey400),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(mobile, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailRow(Icons.badge, "Buckle No", buckleNo),
                const Divider(height: 20),
                _buildDetailRow(Icons.location_on, "Station", station),
                const Divider(height: 20),
                _buildDetailRow(Icons.check_circle, "Status", status, valueColor: status == "Pending" ? Colors.orange : Colors.green),
                const SizedBox(height: 40),
                MaterialButton(
                  onPressed: () {
                    Dcontroller.approvalCoolie(id);
                  },
                  minWidth: double.infinity,
                  height: 44,
                  color: Constants.instance.primary,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Constants.instance.primary),
                  ),
                  child: Text(
                    "Approve",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Constants.instance.white),
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
      Icon(icon, color: Colors.blueGrey, size: 22),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
      ),
      Text(
        value,
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: valueColor),
      ),
    ],
  );
}
