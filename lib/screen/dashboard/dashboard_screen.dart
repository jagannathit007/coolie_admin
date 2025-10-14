import 'dashboard_controller.dart';
import '/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/route_name.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
                child: TabBarView(controller: _tabController, children: [_buildCooliesListTab(controller), _buildPassengerTab(controller)]),
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
          Tab(text: 'Coolies'),
          Tab(text: 'Passenger'),
        ],
      ),
    );
  }

  Widget _buildPassengerTab(DashboardController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.pendingCoolies.isEmpty) {
        return _buildEmptyState(icon: Icons.inbox_outlined, title: "Passenger", subtitle: "Passenger list coming soon");
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
    return _buildEmptyState(icon: Icons.people_outline_rounded, title: "Coolies", subtitle: "Coolies list coming soon");
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

class AddCoolieBottomSheet extends StatefulWidget {
  const AddCoolieBottomSheet({super.key});

  @override
  State<AddCoolieBottomSheet> createState() => _AddCoolieBottomSheetState();
}

class _AddCoolieBottomSheetState extends State<AddCoolieBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _buckleNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _stationIdController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedDeviceType;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _buckleNumberController.dispose();
    _addressController.dispose();
    _stationIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Constants.instance.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.person_add_rounded,
                        color: Constants.instance.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add New Coolie",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            "Fill in the details below",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              
              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      // Image picker
                      _buildImagePicker(),
                      const SizedBox(height: 24),
                      
                      // Name
                      _buildTextField(
                        controller: _nameController,
                        label: "Full Name",
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Mobile Number
                      _buildTextField(
                        controller: _mobileController,
                        label: "Mobile Number",
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          if (value.length != 10) {
                            return 'Please enter valid mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Age
                      _buildTextField(
                        controller: _ageController,
                        label: "Age",
                        icon: Icons.cake_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter age';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Email
                      _buildTextField(
                        controller: _emailController,
                        label: "Email ID",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Gender Dropdown
                      _buildDropdownField(
                        label: "Gender",
                        icon: Icons.wc_outlined,
                        value: _selectedGender,
                        items: const ['Male', 'Female', 'Other'],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Device Type Dropdown
                      _buildDropdownField(
                        label: "Device Type",
                        icon: Icons.phone_android_outlined,
                        value: _selectedDeviceType,
                        items: const ['SmartPhone', 'Other'],
                        onChanged: (value) {
                          setState(() {
                            _selectedDeviceType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select device type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Buckle Number
                      _buildTextField(
                        controller: _buckleNumberController,
                        label: "Buckle Number",
                        icon: Icons.badge_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter buckle number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Address
                      _buildTextField(
                        controller: _addressController,
                        label: "Address",
                        icon: Icons.location_on_outlined,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Station ID
                      _buildTextField(
                        controller: _stationIdController,
                        label: "Station ID",
                        icon: Icons.train_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter station ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      
                      // Submit Button
                      GetBuilder<DashboardController>(
                        builder: (controller) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Constants.instance.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_circle, color: Colors.white, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Add Coolie",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap to add photo",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Constants.instance.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Constants.instance.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: GoogleFonts.poppins(),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: GoogleFonts.poppins()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Constants.instance.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Constants.instance.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: GoogleFonts.poppins(color: Colors.black87),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      final controller = Get.find<DashboardController>();
      controller.addCoolie(
        name: _nameController.text.trim(),
        mobileNo: _mobileController.text.trim(),
        age: _ageController.text.trim(),
        deviceType: _selectedDeviceType!,
        emailId: _emailController.text.trim(),
        gender: _selectedGender!,
        buckleNumber: _buckleNumberController.text.trim(),
        address: _addressController.text.trim(),
        stationId: _stationIdController.text.trim(),
        image: _selectedImage!,
      );
    } else if (_selectedImage == null) {
      Get.snackbar(
        'Error',
        'Please select an image',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
