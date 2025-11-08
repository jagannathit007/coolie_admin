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
      final body = {
        "page": page,
        "limit": limit,
        "search": search,
      };

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
}