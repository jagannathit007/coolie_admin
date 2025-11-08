// coolie_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/coolie_model.dart';
import 'coolie_service.dart';

class CoolieController extends GetxController {
  final CoolieService _coolieService = Get.find<CoolieService>();

  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var isUpdating = false.obs;
  RxList<Coolie> coolies = <Coolie>[].obs;
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
    getAllCoolies();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (hasNextPage.value && !isLoadMore.value && !isLoading.value) {
        getAllCoolies(loadMore: true);
      }
    }
  }

  Future<void> getAllCoolies({
    bool loadMore = false,
    String search = '',
    bool refresh = false,
  }) async {
    try {
      if (search.isNotEmpty) {
        searchQuery.value = search;
        currentPage.value = 1;
        coolies.clear();
      }

      if (refresh) {
        currentPage.value = 1;
        coolies.clear();
      }

      if (loadMore) {
        if (!hasNextPage.value) return;
        isLoadMore.value = true;
        currentPage.value++;
      } else {
        isLoading.value = true;
      }

      final response = await _coolieService.getAllCoolies(
        page: currentPage.value,
        limit: limit.value,
        search: searchQuery.value,
      );

      if (response != null) {
        if (loadMore) {
          coolies.addAll(response.docs);
        } else {
          coolies.value = response.docs;
        }

        _coolieService.allCoolies.value = coolies;

        totalDocs.value = int.tryParse(response.totalDocs) ?? 0;
        totalPages.value = int.tryParse(response.totalPages) ?? 1;
        hasNextPage.value = response.hasNextPage;
        hasPrevPage.value = response.hasPrevPage;
        
        debugPrint("Coolies loaded: ${coolies.length}, Total: $totalDocs, HasNext: $hasNextPage");
      }
    } catch (e) {
      debugPrint("Failed to load coolies: ${e.toString()}");
      if (loadMore) {
        currentPage.value--;
      }
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
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
      isUpdating.value = true;

      final success = await _coolieService.updateCoolie(
        collieId: collieId,
        name: name,
        age: age,
        deviceType: deviceType,
        emailId: emailId,
        gender: gender,
        address: address,
        stationId: stationId,
        isActive: isActive,
        image: image,
      );

      if (success) {
        await getAllCoolies(refresh: true);
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint("Failed to update coolie: ${e.toString()}");
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> updateCoolieStatus(String collieId, bool isActive) async {
    final coolie = coolies.firstWhereOrNull((c) => c.id == collieId);
    if (coolie == null) return false;

    return await updateCoolie(
      collieId: collieId,
      name: coolie.name,
      age: coolie.age,
      deviceType: coolie.deviceType,
      emailId: coolie.emailId,
      gender: coolie.gender,
      address: coolie.address,
      stationId: coolie.stationId.id,
      isActive: isActive.toString(),
      image: null,
    );
  }


  List<Coolie> get globalCoolies => _coolieService.allCoolies;
}