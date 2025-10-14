import 'package:flutter/material.dart';

import '../api constants/api_manager.dart';
import '../api constants/network_constants.dart';
import '../model/admin_model.dart';
import '../model/add_coolie_response_model.dart';
import '../services/app_toasting.dart';
import 'dart:convert';

class AuthenticationRepo {
  Future<AuthenticationRepo> init() async => this;

  Future<AdminSignInResponse?> signIn({
    required String email,
    required String password,
    required String deviceId,
    required String fcm,
  }) async {
    try {
      final result = await apiManager.post(
        NetworkConstants.signIn,
        data: {
          "email": email,
          "password": password,
          // "fcm": fcm,
          // "deviceId": deviceId,
        },
      );
  
      debugPrint("SignIn Raw Response: ${result.data}");
  
      if (result.data is Map<String, dynamic>) {
        return AdminSignInResponse.fromJson(result.data);
      } else {
        debugPrint("Invalid response format: ${result.data}");
        return null;
      }
    } catch (e, stack) {
      debugPrint("SignIn API Error: $e\n$stack");
      return null;
    }
  }

  Future<dynamic> pendingApproval() async {
    try {
      final response = await apiManager.get(NetworkConstants.pendingApproval,);

      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch profile');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching GetPassenger: ${err.toString()}');
      return null;
    }
  }

  Future<AddCoolieResponse?> addCoolie(dynamic data) async {
    try {
      var response = await apiManager.post(NetworkConstants.addCollie, data: data);
      
      debugPrint("Add Coolie Raw Response: ${response.data}");
      
      if (response.status == 200) {
        final Map<String, dynamic> responseData = 
            json.decode(response.data) as Map<String, dynamic>;
        
          return AddCoolieResponse.fromJson(responseData);
      } else {
        AppToasting.showWarning('Failed to add coolie');
        return null;
      }
    } catch (err) {
      AppToasting.showError('Error adding coolie: ${err.toString()}');
      return null;
    }
  }

  Future<dynamic> approveCoolie() async {
    try {
      final response = await apiManager.get(NetworkConstants.addCollie,);

      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch profile');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching GetPassenger: ${err.toString()}');
      return null;
    }
  }
}
