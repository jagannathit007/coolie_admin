import 'package:coolie_admin/routes/route_name.dart';
import 'package:coolie_admin/services/app_toasting.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/pending_coolie_list_model.dart';
import '../../model/station_model.dart';
import '../../repositories/authentication_repo.dart';
import 'dart:io';

import '../../services/app_storage.dart';

class DashboardController extends GetxController {
  final AuthenticationRepo _authRepo = AuthenticationRepo();
  var isLoading = false.obs;

  RxList<PendingCooliList> pendingCoolies = <PendingCooliList>[].obs;
  RxList<Station> stations = <Station>[].obs;
  RxString selectedStationId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    pendingCoolie();
    getAllStations();
  }

  Future<void> getAllStations() async {
    try {
      final response = await _authRepo.getAllStation();
      if (response != null && response.station.isNotEmpty) {
        stations.value = response.station;
        debugPrint("Stations loaded: ${stations.length}");
      }
    } catch (e) {
      debugPrint("Failed to load stations: ${e.toString()}");
    }
  }

  Future<void> pendingCoolie() async {
    try {
      isLoading.value = true;
      final response = await _authRepo.pendingApproval();
      debugPrint("MODEL $response");
      pendingCoolies.value = (response as List).map((e) => PendingCooliList.fromJson(e as Map<String, dynamic>)).toList();

      debugPrint("parsed list: ${pendingCoolies.length}");
    } catch (e) {
      debugPrint("Failed to load Passenger: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCoolie({
    required String name,
    required String mobileNo,
    required String age,
    required String deviceType,
    required String emailId,
    required String gender,
    required String buckleNumber,
    required String address,
    required File image,
  }) async {
    try {
      isLoading.value = true;

      if (selectedStationId.isEmpty) {
        AppToasting.showError('Please select a station');
        return;
      }

      final formData = dio.FormData.fromMap({
        "name": name,
        "mobileNo": mobileNo,
        "age": age,
        "deviceType": deviceType,
        "emailId": emailId,
        "gender": gender,
        "buckleNumber": buckleNumber,
        "address": address,
        "stationId": selectedStationId.value,
      });

      formData.files.add(MapEntry('image', await dio.MultipartFile.fromFile(image.path, filename: 'coolie_${DateTime.now().millisecondsSinceEpoch}.jpg')));

      final response = await _authRepo.addCoolie(formData);

      debugPrint("Add Coolie Response: $response");

      if (response != null) {
        Get.back();
        AppToasting.showSuccess('Coolie added successfully! Face registered. Awaiting admin approval.');
        await pendingCoolie();
      }
    } catch (e) {
      Get.back();
      debugPrint("Failed to add coolie: ${e.toString()}");
      AppToasting.showError('Failed to add coolie: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveCoolie() async {
    try {
      isLoading.value = true;
      final response = await _authRepo.approveCoolie();
      debugPrint("MODELLL $response");
      await pendingCoolie();
    } catch (e) {
      debugPrint("Failed to load Passenger: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await AppStorage.clearAll();

      AppToasting.showSuccess('Logged out successfully!');

      Get.offAllNamed(RouteName.signIn);
    } catch (e) {
      debugPrint("Logout error: ${e.toString()}");
      AppToasting.showError('Logout failed: ${e.toString()}');
    }
  }
}
