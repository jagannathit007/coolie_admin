import 'package:coolie_admin/api%20constants/network_constants.dart';
import 'package:coolie_admin/screen/coolie listing/coolie_controller.dart';
import 'package:coolie_admin/screen/coolie listing/coolie_service.dart';
import 'package:coolie_admin/screen/coolie listing/editCoolieBottomSheet.dart';
import 'package:coolie_admin/screen/dashboard/addCoolieBottomSheet.dart';
import 'package:coolie_admin/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/coolie_model.dart';

class CoolieScreen extends StatefulWidget {
  const CoolieScreen({super.key});

  @override
  State<CoolieScreen> createState() => _CoolieScreenState();
}

class _CoolieScreenState extends State<CoolieScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounce;
  late CoolieController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<CoolieService>()) {
      Get.put(CoolieService());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoolieController>(
      init: CoolieController(),
      builder: (controller) {
        this.controller = controller;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildModernAppBar(),
          body: Column(
            children: [
              _buildSearchSection(controller),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.coolies.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.coolies.isEmpty) {
                    return _buildEmptyState(controller);
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification) {
                        if (_searchFocusNode.hasFocus) {
                          _searchFocusNode.unfocus();
                        }
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: () {
                        _searchFocusNode.unfocus();
                        return controller.getAllCoolies(refresh: true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: ListView.builder(
                          controller: controller.scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          itemCount:
                              controller.coolies.length +
                              (controller.isLoadMore.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.coolies.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final coolie = controller.coolies[index];
                            return _buildCoolieCard(coolie, index, controller);
                          },
                        ),
                      ),
                    ),
                  );
                }),
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
      iconTheme: IconThemeData(color: Constants.instance.white),
      backgroundColor: Constants.instance.primary,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Coolie Management",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(CoolieController controller) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Obx(
        () => TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: "Search coolies by name, mobile, or buckle number...",
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[600]),
            suffixIcon: controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear_rounded, color: Colors.grey[600]),
                    onPressed: () {
                      _searchController.clear();
                      controller.searchQuery.value = '';
                      _searchFocusNode.unfocus();
                      controller.getAllCoolies(refresh: true);
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 14),
          onChanged: (value) {
            controller.searchQuery.value = value;

            // Cancel previous timer
            _searchDebounce?.cancel();

            if (value.isEmpty) {
              controller.getAllCoolies(refresh: true);
            } else {
              // Debounce search - wait 500ms after user stops typing
              _searchDebounce = Timer(const Duration(milliseconds: 500), () {
                if (_searchController.text == value) {
                  controller.getAllCoolies(search: value, refresh: true);
                }
              });
            }
          },
          onSubmitted: (value) {
            _searchFocusNode.unfocus();
            controller.getAllCoolies(search: value, refresh: true);
          },
        ),
      ),
    );
  }

  Widget _buildCoolieCard(
    Coolie coolie,
    int index,
    CoolieController controller,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _searchFocusNode.unfocus();
              _showCoolieDetailsBottomSheet(coolie);
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: ClipOval(
                      child: coolie.image.url.isNotEmpty
                          ? Image.network(
                              "${NetworkConstants.imageURL}${coolie.image.url}",
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 32,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 56,
                                      height: 56,
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                            )
                          : Container(
                              width: 56,
                              height: 56,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person_rounded,
                                size: 32,
                                color: Colors.grey[400],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Coolie Info
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      coolie.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.badge_outlined,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Buckle: ${coolie.buckleNumber}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 14,
                                    color: Colors.amber[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${coolie.rating} (${coolie.totalRatings} reviews)",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildStatusBadge(coolie),
                            const SizedBox(height: 8),
                            _buildEditButton(coolie, controller),
                          ],
                        ),
                      ],
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

  Widget _buildEditButton(Coolie coolie, CoolieController controller) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _searchFocusNode.unfocus();
          _showEditCoolieBottomSheet(coolie);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Constants.instance.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Constants.instance.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.edit_rounded,
                size: 14,
                color: Constants.instance.primary,
              ),
              const SizedBox(width: 4),
              Text(
                "Edit",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Constants.instance.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditCoolieBottomSheet(Coolie coolie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return EditCoolieBottomSheet(coolie: coolie);
      },
    );
  }

  Widget _buildStatusBadge(Coolie coolie) {
    Color badgeColor;
    Color textColor;
    String status;
    IconData icon;

    if (!coolie.isApproved) {
      badgeColor = Colors.orange.withOpacity(0.1);
      textColor = Colors.orange[800]!;
      status = "Pending";
      icon = Icons.pending_actions_rounded;
    } else if (coolie.isActive && coolie.isLoggedIn) {
      badgeColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green[800]!;
      status = "Active";
      icon = Icons.check_circle_rounded;
    } else if (coolie.isActive) {
      badgeColor = Colors.blue.withOpacity(0.1);
      textColor = Colors.blue[800]!;
      status = "Inactive";
      icon = Icons.pause_circle_outline_rounded;
    } else {
      badgeColor = Colors.grey.withOpacity(0.1);
      textColor = Colors.grey[800]!;
      status = "Inactive";
      icon = Icons.block_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: GoogleFonts.poppins(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(CoolieController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No Coolies Found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.searchQuery.value.isNotEmpty
                  ? "Try searching with different keywords"
                  : "No coolies available at the moment",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        _searchFocusNode.unfocus();
        _showAddCoolieBottomSheet(context);
      },
      backgroundColor: Constants.instance.primary,
      elevation: 6,
      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
      label: Text(
        "Add Coolie",
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
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

  void _showCoolieDetailsBottomSheet(Coolie coolie) {
    _searchFocusNode.unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
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
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Profile Header
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Constants.instance.primary.withOpacity(0.1),
                                Constants.instance.primary.withOpacity(0.05),
                              ],
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: coolie.image.url.isNotEmpty
                                      ? Image.network(
                                          "${NetworkConstants.imageURL}${coolie.image.url}",
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 64,
                                                  height: 64,
                                                  color: Colors.grey[200],
                                                  child: Icon(
                                                    Icons.person_rounded,
                                                    size: 40,
                                                    color: Colors.grey[400],
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          width: 64,
                                          height: 64,
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.person_rounded,
                                            size: 40,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coolie.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          coolie.mobileNo,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              _buildStatusBadge(coolie),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Details Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                Icons.badge_outlined,
                                "Buckle Number",
                                coolie.buckleNumber,
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.location_on_outlined,
                                "Station",
                                coolie.stationId.name,
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.email_outlined,
                                "Email",
                                coolie.emailId,
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.person_outline_rounded,
                                "Gender",
                                coolie.gender,
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.cake_outlined,
                                "Age",
                                "${coolie.age} years",
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.star_rounded,
                                "Rating",
                                "${coolie.rating} (${coolie.totalRatings} reviews)",
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.check_circle_outline,
                                "Completed Bookings",
                                coolie.completedBookings,
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.cancel_outlined,
                                "Rejected Bookings",
                                coolie.rejectedBookings,
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.currency_rupee_rounded,
                                "Base Rate",
                                "₹${coolie.rateCard.baseRate}",
                              ),
                            ],
                          ),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Constants.instance.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
