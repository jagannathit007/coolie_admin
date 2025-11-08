import 'package:flutter/material.dart';

import '../api constants/api_manager.dart';
import '../api constants/network_constants.dart';
import '../model/admin_model.dart';
import '../model/add_coolie_response_model.dart';
import '../model/dashboard_stats_model.dart';
import '../model/station_model.dart';
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

  Future<DashboardStats?> getDashboardStats() async {
    try {
      final response = await apiManager.get(NetworkConstants.getStats);

      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return null;
      }

      debugPrint("Dashboard Stats Data ${response.data}");

      if (response.data != null) {
        return DashboardStats.fromJson(response.data);
      } else {
        AppToasting.showWarning('Invalid dashboard stats data format');
        return null;
      }
    } catch (err) {
      AppToasting.showError('Error fetching dashboard stats: ${err.toString()}');
      return null;
    }
  }

  Future<dynamic> pendingApproval() async {
    try {
      final response = await apiManager.get(NetworkConstants.pendingApproval);

      if (response.status != 200) {
        AppToasting.showWarning(
          response.data?.message ?? 'Failed to fetch profile',
        );
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching GetPassenger: ${err.toString()}');
      return null;
    }
  }

  Future<StationListData?> getAllStation() async {
    try {
      final body = {
        "page": 1,
        "limit": 200,
      };
      final response = await apiManager.post(NetworkConstants.getAllStation, data: body);

      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return null;
      }

      debugPrint("Station Data ${response.data}");

      if (response.data != null) {
        return StationListData.fromJson(response.data);
      } else {
        AppToasting.showWarning('Invalid station data format');
        return null;
      }
    } catch (err) {
      AppToasting.showError('Error fetching stations: ${err.toString()}');
      return null;
    }
  }

  Future<AddCoolieResponse?> addCoolie(dynamic data) async {
    try {
      var response = await apiManager.post(
        NetworkConstants.addCollie,
        data: data,
      );

      debugPrint("Add Coolie Raw Response: ${response.data}");

      if (response.status == 200) {
        if (response.data == null) {
          AppToasting.showWarning(response.message);
          return null;
        }

        final Map<String, dynamic> responseData;

        if (response.data is Map<String, dynamic>) {
          responseData = response.data as Map<String, dynamic>;
        } else if (response.data is String) {
          responseData = json.decode(response.data) as Map<String, dynamic>;
        } else {
          debugPrint(
            "Unexpected response data type: ${response.data.runtimeType}",
          );
          AppToasting.showWarning('Unexpected response format');
          return null;
        }

        return AddCoolieResponse.fromJson(responseData);
      } else {
        AppToasting.showWarning('Failed to add coolie: ${response.message}');
        return null;
      }
    } catch (err) {
      debugPrint("Error adding coolie: ${err.toString()}");
      AppToasting.showError('Error adding coolie: ${err.toString()}');
      return null;
    }
  }

  Future<dynamic> approveCoolie() async {
    try {
      final response = await apiManager.get(NetworkConstants.addCollie);

      if (response.status != 200) {
        AppToasting.showWarning(
          response.data?.message ?? 'Failed to fetch profile',
        );
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
