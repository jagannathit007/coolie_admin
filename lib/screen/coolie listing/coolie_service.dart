import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api constants/api_manager.dart';
import '../../api constants/network_constants.dart';
import '../../model/coolie_model.dart';
import '../../services/app_toasting.dart';

class CoolieService extends GetxService {
  // Global variable for all coolies
  RxList<Coolie> allCoolies = <Coolie>[].obs;

  Future<CoolieListData?> getAllCoolies({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    try {
      final body = {"page": page, "limit": limit, "search": search};

      final response = await apiManager.post(
        NetworkConstants.getAllCoolies,
        data: body,
      );

      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return null;
      }

      debugPrint("Coolie Data ${response.data}");

      if (response.data != null) {
        return CoolieListData.fromJson(response.data);
      } else {
        AppToasting.showWarning('Invalid coolie data format');
        return null;
      }
    } catch (err) {
      AppToasting.showError('Error fetching coolies: ${err.toString()}');
      return null;
    }
  }

  Future<bool> updateCoolie({
    required String collieId,
    required String name,
    required String age,
    required String deviceType,
    required String emailId,
    required String gender,
    required String address,
    required String stationId,
    required String isActive,
    File? image,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        "collieId": collieId,
        "name": name,
        "age": age,
        "deviceType": deviceType,
        "emailId": emailId,
        "gender": gender,
        "address": address,
        "stationId": stationId,
        "isActive": isActive,
      });

      // Add image to form data if provided
      if (image != null) {
        formData.files.add(
          MapEntry(
            'image',
            await dio.MultipartFile.fromFile(
              image.path,
              filename: 'coolie_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        );
      }

      final response = await apiManager.post(
        NetworkConstants.updateCoolie,
        data: formData,
      );

      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return false;
      }

      debugPrint("Coolie updated successfully: ${response.data}");

      AppToasting.showSuccess(response.message);
      return true;
    } catch (err) {
      AppToasting.showError('Error updating coolie: ${err.toString()}');
      return false;
    }
  }
}
