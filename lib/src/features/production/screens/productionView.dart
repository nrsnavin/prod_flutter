import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:production/src/common_widgets/appBar.dart';
import 'package:production/src/features/production/controllers/productionController.dart';
import 'package:production/src/features/production/controllers/productionViewController.dart';
import 'package:production/src/features/production/models/productionBrief.dart';
import 'package:production/src/features/production/screens/productionOnDate.dart';
import 'package:production/src/features/production/screens/shiftViewPage.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ViewProduction extends StatefulWidget {
  const ViewProduction({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ViewProduction();
  }
}

class _ViewProduction extends State<ViewProduction> {
  final controller = Get.put(ProductionController());
  String _range = '';

  final DateRangePickerController _pickerController =
      DateRangePickerController();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final PickerDateRange range = args.value;

      if (range.startDate != null && range.endDate != null) {
        final start = range.startDate!;
        final end = range.endDate!;

        final difference = end.difference(start).inDays;

        if (difference > 30) {
          // 🚫 Invalid range – reset end date
          _pickerController.selectedRange = PickerDateRange(
            start,
            start.add(const Duration(days: 30)),
          );

          Get.snackbar('Invalid Range', 'Date range cannot exceed 30 days');
        } else {
          controller.fetchDateRange(
            DateFormat('yyyy-MM-dd').format(args.value.startDate),
            DateFormat(
              'yyyy-MM-dd',
            ).format(args.value.endDate ?? args.value.startDate),
          );
        }
      }
    }
    setState(() {
      _range =
          '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
          // ignore: lines_longer_than_80_chars
          ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: NAppBar(showBackArrow: true),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          dragStartBehavior: DragStartBehavior.start,
          controller: ScrollController(
            debugLabel: "nvain",
            keepScrollOffset: true,
          ),

          clipBehavior: Clip.hardEdge,

          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                const Text(
                  "Select Date Range To View Production",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  child: SfDateRangePicker(
                    controller: _pickerController,
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                      DateTime.now().subtract(const Duration(days: 7)),
                      DateTime.now(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Selected range: $_range',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Obx(
                  () => SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: Center(
                      // FutureBuilder
                      child: controller.days.value.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.days.length,
                              itemBuilder: (_, index) {
                                final day = controller.days[index];

                                return Card(
                                  child: ListTile(
                                    title: Text(day.date),
                                    subtitle: Text(
                                      "Total: ${day.totalProduction.toStringAsFixed(2)} m",
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                    ),
                                    onTap: () {
                                      Get.to(
                                        () => ShiftDayViewPage(),
                                        arguments: day.date,
                                      );
                                    },
                                  ),
                                );
                              },
                            )
                          : const Text("Loading"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }

  Widget _shiftCard(ProductionBrief order) {
    return InkWell(
      onDoubleTap: () => {
        Get.to(() => PPonDateScreen(), arguments: [order.date]),
      },
      child: Container(
        color: Colors.grey.shade300,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        width: double.maxFinite,
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  "Date-",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                Text(
                  order.date,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  "Total Production:",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text(
                  order.production.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// function to display fetched data on screen
