import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderElasticRow {
  RxnString elasticId = RxnString();
  final TextEditingController qtyCtrl = TextEditingController();

  void dispose() {
    qtyCtrl.dispose();
  }
}
