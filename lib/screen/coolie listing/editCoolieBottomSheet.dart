import 'dart:io';
import 'package:coolie_admin/api%20constants/network_constants.dart';
import 'package:coolie_admin/screen/coolie listing/coolie_controller.dart';
import 'package:coolie_admin/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/coolie_model.dart';
import '../dashboard/dashboard_controller.dart';

class EditCoolieBottomSheet extends StatefulWidget {
  final Coolie coolie;

  const EditCoolieBottomSheet({super.key, required this.coolie});

  @override
  State<EditCoolieBottomSheet> createState() => _EditCoolieBottomSheetState();
}

class _EditCoolieBottomSheetState extends State<EditCoolieBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  String? _selectedGender;
  String? _selectedDeviceType;
  String? _selectedStation;
  String? _selectedIsActive;
  File? _selectedImage;
  String? _currentImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.coolie.name);
    _ageController = TextEditingController(text: widget.coolie.age);
    _emailController = TextEditingController(text: widget.coolie.emailId);
    _addressController = TextEditingController(text: widget.coolie.address);
    _selectedGender = widget.coolie.gender;
    _selectedDeviceType = widget.coolie.deviceType;
    _selectedStation = widget.coolie.stationId.id;
    _selectedIsActive = widget.coolie.isActive ? 'true' : 'false';
    _currentImageUrl = widget.coolie.image.url;
    
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({ImageSource source = ImageSource.camera}) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _currentImageUrl = null; // Clear URL when new image is selected
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(source: ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(source: ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
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
          body: GetBuilder<CoolieController>(
            builder: (controller) {
              return Obx(() {
                if (controller.isUpdating.value) {
                  return Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Updating Coolie...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
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
                                Icons.edit_rounded,
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
                                    "Edit Coolie",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    "Update coolie details",
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
                          child: SingleChildScrollView(
                            controller: scrollController,
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

                                // Station Dropdown
                                GetBuilder<DashboardController>(
                                  builder: (controller) {
                                    // Create station display names list
                                    List<String>
                                    stationDisplayNames = controller.stations
                                        .map(
                                          (station) =>
                                              '${station.name} (${station.code})',
                                        )
                                        .toList();

                                    // Get the selected station display name
                                    String? selectedDisplayName;
                                    if (_selectedStation != null) {
                                      final selectedStation = controller
                                          .stations
                                          .firstWhere(
                                            (station) =>
                                                station.id == _selectedStation,
                                          );
                                      selectedDisplayName =
                                          '${selectedStation.name} (${selectedStation.code})';
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
                                            final selectedStation = controller
                                                .stations
                                                .firstWhere(
                                                  (station) =>
                                                      '${station.name} (${station.code})' ==
                                                      value,
                                                );
                                            _selectedStation =
                                                selectedStation.id;
                                            controller.selectedStationId.value =
                                                selectedStation.id;
                                          } else {
                                            _selectedStation = null;
                                            controller.selectedStationId.value =
                                                '';
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
                                const SizedBox(height: 16),

                                // Active Status Dropdown
                                _buildDropdownField(
                                  label: "Status",
                                  icon: Icons.toggle_on_outlined,
                                  value: _selectedIsActive == 'true' ? 'Active' : 'Inactive',
                                  items: const ['Active', 'Inactive'],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedIsActive = value == 'Active' ? 'true' : 'false';
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select status';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),

                                // Submit Button
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Constants.instance.primary,
                                        Constants.instance.primary.withOpacity(0.8),
                                      ],
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
                                    onPressed: controller.isUpdating.value ? null : _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: controller.isUpdating.value
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
                                              const Icon(Icons.save_rounded, color: Colors.white, size: 20),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Update Coolie",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Center(
        child: Stack(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: _selectedImage != null
                  ? ClipOval(child: Image.file(_selectedImage!, fit: BoxFit.cover))
                  : _currentImageUrl != null && _currentImageUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            "${NetworkConstants.imageURL}$_currentImageUrl",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        )
                      : _buildPlaceholderImage(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Constants.instance.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Tap to change photo",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
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
        decoration: BoxDecoration(
          color: Constants.instance.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.arrow_drop_down_rounded,
          size: 24,
          color: Constants.instance.primary,
        ),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        suffixIcon: value != null && value.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear_rounded,
                  size: 18,
                  color: Colors.grey[500],
                ),
                onPressed: () {
                  onChanged(null);
                },
              )
            : null,
      ),
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.grey[800],
      ),
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((String item) {
          return Container(
            alignment: Alignment.centerLeft,
            child: Text(
              value ?? '',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<CoolieController>();
      controller.updateCoolie(
        collieId: widget.coolie.id,
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        deviceType: _selectedDeviceType!,
        emailId: _emailController.text.trim(),
        gender: _selectedGender!,
        address: _addressController.text.trim(),
        stationId: _selectedStation!,
        isActive: _selectedIsActive!,
        image: _selectedImage,
      ).then((success) {
        if (success) {
          Navigator.pop(context);
        }
      });
    }
  }
}

