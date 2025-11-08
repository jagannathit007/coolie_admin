// passenger_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/passenger_model.dart';
import 'passenger_service.dart';

class PassengerController extends GetxController {
  final PassengerService _passengerService = Get.find<PassengerService>();

  var isLoading = false.obs;
  var isLoadMore = false.obs;
  RxList<Passenger> passengers = <Passenger>[].obs;
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
    getAllPassengers();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (hasNextPage.value && !isLoadMore.value && !isLoading.value) {
        getAllPassengers(loadMore: true);
      }
    }
  }

  Future<void> getAllPassengers({
    bool loadMore = false,
    String search = '',
    bool refresh = false,
  }) async {
    try {
      if (search.isNotEmpty) {
        searchQuery.value = search;
        currentPage.value = 1;
        passengers.clear();
      }

      if (refresh) {
        currentPage.value = 1;
        passengers.clear();
      }

      if (loadMore) {
        if (!hasNextPage.value) return;
        isLoadMore.value = true;
        currentPage.value++;
      } else {
        isLoading.value = true;
      }

      final response = await _passengerService.getAllPassengers(
        page: currentPage.value,
        limit: limit.value,
        search: searchQuery.value,
      );

      if (response != null) {
        if (loadMore) {
          passengers.addAll(response.docs);
        } else {
          passengers.value = response.docs;
        }

        _passengerService.allPassengers.value = passengers;

        totalDocs.value = int.tryParse(response.totalDocs) ?? 0;
        totalPages.value = int.tryParse(response.totalPages) ?? 1;
        hasNextPage.value = response.hasNextPage;
        hasPrevPage.value = response.hasPrevPage;
        
        debugPrint("Passengers loaded: ${passengers.length}, Total: $totalDocs, HasNext: $hasNextPage");
      }
    } catch (e) {
      debugPrint("Failed to load passengers: ${e.toString()}");
      if (loadMore) {
        currentPage.value--;
      }
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  List<Passenger> get globalPassengers => _passengerService.allPassengers;
}