

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../model/pending_coolie_list_model.dart';
import '../../repositories/authentication_repo.dart';

class DashboardController extends GetxController{
  final AuthenticationRepo _authRepo = AuthenticationRepo();
  var isLoading = false.obs;

  RxList<PendingCooliList> pendingCoolies = <PendingCooliList>[].obs;


  @override
  void onInit() {
    super.onInit();
    pendingCoolie();
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

  Future<void> approvalCoolie(id) async {
    try {
      isLoading.value = true;
      final response = await _authRepo.approvalCoolie(id);
      debugPrint("MODELLL $response");
      await pendingCoolie();

    } catch (e) {
      debugPrint("Failed to load Passenger: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }


}