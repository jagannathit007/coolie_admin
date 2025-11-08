import 'package:coolie_admin/api%20constants/network_constants.dart';
import 'package:coolie_admin/screen/coolie passenger/passenger_controller.dart';
import 'package:coolie_admin/screen/coolie passenger/passenger_service.dart';
import 'package:coolie_admin/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/passenger_model.dart';

class PassengerScreen extends StatefulWidget {
  const PassengerScreen({super.key});

  @override
  State<PassengerScreen> createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounce;
  late PassengerController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<PassengerService>()) {
      Get.put(PassengerService());
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
    return GetBuilder<PassengerController>(
      init: PassengerController(),
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
                      controller.passengers.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.passengers.isEmpty) {
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
                        return controller.getAllPassengers(refresh: true);
                      },
                      child: ListView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        itemCount:
                            controller.passengers.length +
                            (controller.isLoadMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.passengers.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          final passenger = controller.passengers[index];
                          return _buildPassengerCard(passenger, index, controller);
                        },
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
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
            "Passenger Management",
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

  Widget _buildSearchSection(PassengerController controller) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Obx(() => TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: "Search passengers by name, mobile, or email...",
              hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[600]),
              suffixIcon: controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear_rounded, color: Colors.grey[600]),
                      onPressed: () {
                        _searchController.clear();
                        controller.searchQuery.value = '';
                        _searchFocusNode.unfocus();
                        controller.getAllPassengers(refresh: true);
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
                controller.getAllPassengers(refresh: true);
              } else {
                // Debounce search - wait 500ms after user stops typing
                _searchDebounce = Timer(const Duration(milliseconds: 500), () {
                  if (_searchController.text == value) {
                    controller.getAllPassengers(search: value, refresh: true);
                  }
                });
              }
            },
            onSubmitted: (value) {
              _searchFocusNode.unfocus();
              controller.getAllPassengers(search: value, refresh: true);
            },
          )),
    );
  }

  Widget _buildPassengerCard(Passenger passenger, int index, PassengerController controller) {
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
              _showPassengerDetailsBottomSheet(passenger);
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    padding: const EdgeInsets.all(4),
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //     colors: [
                    //       Colors.blue,
                    //       Colors.blue.withOpacity(0.8),
                    //     ],
                    //   ),
                    //   shape: BoxShape.circle,
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.blue.withOpacity(0.3),
                    //       blurRadius: 8,
                    //       offset: const Offset(0, 2),
                    //     ),
                    //   ],
                    // ),
                    child: ClipOval(
                      child: passenger.userImage.isNotEmpty
                          ? Image.network(
                              "${NetworkConstants.imageURL}${passenger.userImage}",
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
                  // Passenger Info
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
                                      passenger.name,
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
                                    Icons.phone,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    passenger.mobileNo,
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
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      passenger.addressComponent.formattedAddress,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(passenger),
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

  Widget _buildStatusBadge(Passenger passenger) {
    Color badgeColor;
    Color textColor;
    String status;
    IconData icon;

    if (!passenger.isVerified) {
      badgeColor = Colors.orange.withOpacity(0.1);
      textColor = Colors.orange[800]!;
      status = "Unverified";
      icon = Icons.verified_outlined;
    } else if (passenger.isActive) {
      badgeColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green[800]!;
      status = "Active";
      icon = Icons.check_circle_rounded;
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

  Widget _buildEmptyState(PassengerController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No Passengers Found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
                controller.searchQuery.value.isNotEmpty
                    ? "Try searching with different keywords"
                    : "No passengers available at the moment",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  void _showPassengerDetailsBottomSheet(Passenger passenger) {
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
                                Colors.blue.withOpacity(0.1),
                                Colors.blue.withOpacity(0.05),
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
                                  child: passenger.userImage.isNotEmpty
                                      ? Image.network(
                                          "${NetworkConstants.imageURL}${passenger.userImage}",
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
                                      passenger.name,
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
                                          passenger.mobileNo,
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
                              _buildStatusBadge(passenger),
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
                                Icons.email_outlined,
                                "Email",
                                passenger.emailId,
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.person_outline_rounded,
                                "Gender",
                                passenger.gender.isNotEmpty
                                    ? passenger.gender
                                    : "Not specified",
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.location_on_outlined,
                                "Address",
                                passenger.addressComponent.formattedAddress,
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.check_circle_outline,
                                "Status",
                                passenger.isActive ? "Active" : "Inactive",
                                valueColor: passenger.isActive
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(
                                Icons.verified_user_outlined,
                                "Verification",
                                passenger.isVerified ? "Verified" : "Unverified",
                                valueColor: passenger.isVerified
                                    ? Colors.green
                                    : Colors.orange,
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

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color valueColor = Colors.black87,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue, size: 20),
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
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
