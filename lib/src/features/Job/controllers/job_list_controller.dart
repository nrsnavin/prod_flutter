import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:production/src/features/Job/services/job_api.dart';

import '../models/JobListModel.dart';





class JobListController extends GetxController {


  var jobs = <JobListModel>[].obs;
  var isLoading = false.obs;

  var page = 1;
  var hasMore = true;

  var selectedStatus = "all".obs;
  var searchText = "".obs;

  final scrollController = ScrollController();
  final searchController = TextEditingController();

  @override
  void onInit() {
    fetchJobs();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent &&
        hasMore) {
      page++;
      fetchJobs();
    }
  }

  Future<void> fetchJobs({bool reset = false}) async {
    if (reset) {
      page = 1;
      jobs.clear();
      hasMore = true;
    }

    if (!hasMore) return;

    isLoading.value = true;

    final response = await JobApi.getJobs(
      page: page,
      status: selectedStatus.value,
      search: searchText.value,
    );

    final List data = response.data["jobs"];

    final newJobs =
    data.map((e) => JobListModel.fromJson(e)).toList();

    jobs.addAll(newJobs);

    if (newJobs.length < 10) hasMore = false;

    isLoading.value = false;
  }

  void changeStatus(String status) {
    selectedStatus.value = status;
    fetchJobs(reset: true);
  }

  void searchJob(String value) {
    searchText.value = value;
    fetchJobs(reset: true);
  }
}
