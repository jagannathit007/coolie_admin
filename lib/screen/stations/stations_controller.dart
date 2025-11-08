// controllers/station_controller.dart
import 'package:coolie_admin/screen/stations/stations_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/station_model.dart';


class StationController extends GetxController {
  final StationService _stationService = Get.find<StationService>();

  var isLoading = false.obs;
  var isLoadMore = false.obs;
  RxList<Station> stations = <Station>[].obs;
  RxString searchQuery = ''.obs;
  
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalDocs = 0.obs;
  var limit = 10.obs;
  var hasNextPage = false.obs;
  var hasPrevPage = false.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    getAllStations();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (hasNextPage.value && !isLoadMore.value && !isLoading.value) {
        getAllStations(loadMore: true);
      }
    }
  }

  Future<void> getAllStations({
    bool loadMore = false,
    String search = '',
    bool refresh = false,
  }) async {
    try {
      if (search.isNotEmpty) {
        searchQuery.value = search;
        currentPage.value = 1;
        stations.clear();
      }

      if (refresh) {
        currentPage.value = 1;
        stations.clear();
      }

      if (loadMore) {
        if (!hasNextPage.value) return;
        isLoadMore.value = true;
        currentPage.value++;
      } else {
        isLoading.value = true;
      }

      final response = await _stationService.getAllStations(
        page: currentPage.value,
        limit: limit.value,
        search: searchQuery.value,
      );

      if (response != null) {
        if (loadMore) {
          stations.addAll(response.stations.docs);
        } else {
          stations.value = response.stations.docs;
        }

        _stationService.allStations.value = stations;

        totalDocs.value = int.tryParse(response.stations.totalDocs) ?? 0;
        totalPages.value = int.tryParse(response.stations.totalPages) ?? 1;
        hasNextPage.value = response.stations.hasNextPage;
        hasPrevPage.value = response.stations.hasPrevPage;
        
        debugPrint("Stations loaded: ${stations.length}, Total: $totalDocs, HasNext: $hasNextPage");
      }
    } catch (e) {
      debugPrint("Failed to load stations: ${e.toString()}");
      if (loadMore) {
        currentPage.value--;
      }
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  List<Station> get globalStations => _stationService.allStations;
}