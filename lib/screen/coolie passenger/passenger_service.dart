import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api constants/api_manager.dart' show apiManager;
import '../../api constants/network_constants.dart';
import '../../model/passenger_model.dart';
import '../../services/app_toasting.dart';

class PassengerService extends GetxService {
  RxList<Passenger> allPassengers = <Passenger>[].obs;
  
  Future<PassengerListData?> getAllPassengers({
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
        NetworkConstants.getAllPassengers,
        data: body,
      );

      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return null;
      }

      debugPrint("Passenger Data ${response.data}");

      if (response.data != null) {
        return PassengerListData.fromJson(response.data);
      } else {
        AppToasting.showWarning('Invalid passenger data format');
        return null;
      }
    } catch (err) {
      AppToasting.showError('Error fetching passengers: ${err.toString()}');
      return null;
    }
  }
}