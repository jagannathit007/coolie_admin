import 'dart:io';
import 'package:coolie_admin/screen/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_constants.dart';

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

  String? _selectedGender;
  String? _selectedDeviceType;
  String? _selectedStation; // Add this for station selection
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
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Constants.instance.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.person_add_rounded, color: Constants.instance.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add New Coolie",
                              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                            ),
                            Text("Fill in the details below", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
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
                            isMobileNumber: true,
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

                          // Station Dropdown - Using _buildDropdownField
                          GetBuilder<DashboardController>(
                            builder: (controller) {
                              // Create station display names list
                              List<String> stationDisplayNames = controller.stations.map((station) => '${station.name} (${station.code})').toList();

                              // Get the selected station display name
                              String? selectedDisplayName;
                              if (_selectedStation != null) {
                                final selectedStation = controller.stations.firstWhere((station) => station.id == _selectedStation);
                                selectedDisplayName = '${selectedStation.name} (${selectedStation.code})';
                              }

                              return _buildDropdownField(
                                label: "Station",
                                icon: Icons.train_outlined,
                                value: selectedDisplayName,
                                items: stationDisplayNames,
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null) {
                                      // Find the station ID from the display name
                                      final selectedStation = controller.stations.firstWhere((station) => '${station.name} (${station.code})' == value);
                                      _selectedStation = selectedStation.id;
                                      controller.selectedStationId.value = selectedStation.id;
                                    } else {
                                      _selectedStation = null;
                                      controller.selectedStationId.value = '';
                                    }
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a station';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 32),

                          // Submit Button
                          GetBuilder<DashboardController>(
                            builder: (controller) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)]),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Constants.instance.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                                ),
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value ? null : _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: controller.isLoading.value
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.add_circle, color: Colors.white, size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Add Coolie",
                                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Center(
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
          ),
          clipBehavior: Clip.antiAlias,
          child: _selectedImage != null
              ? ClipOval(child: Image.file(_selectedImage!, fit: BoxFit.cover))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Tap to add photo",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
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
    bool isMobileNumber = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) => null,
      maxLength: isMobileNumber ? 10 : null,
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
    bool isExpanded = true,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              item,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      isExpanded: isExpanded,
      dropdownColor: Colors.white,
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Constants.instance.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(Icons.arrow_drop_down_rounded, size: 24, color: Constants.instance.primary),
      ),
      iconSize: 24,
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      menuMaxHeight: 300,
      autofocus: false,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Select $label',
        hintStyle: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 16),
        prefixIcon: Container(
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: Constants.instance.primary, size: 20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        suffixIcon: value != null && value.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear_rounded, size: 18, color: Colors.grey[500]),
                onPressed: () {
                  onChanged(null);
                },
              )
            : null,
      ),
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((String item) {
          return Container(
            alignment: Alignment.centerLeft,
            child: Text(
              value ?? '',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800]),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
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
        image: _selectedImage!,
      );
    } else if (_selectedImage == null) {
      Get.snackbar('Error', 'Please select an image', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
