import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api constants/api_manager.dart';
import '../../api constants/network_constants.dart';
import '../../model/station_model.dart';
import '../../services/app_toasting.dart';

class StationService extends GetxService {
  RxList<Station> allStations = <Station>[].obs;
  
  Future<StationListData?> getAllStations({
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
        NetworkConstants.getAllStation,
        data: body,
      );

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
}