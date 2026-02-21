import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/features/Covering/screens/covering_list.dart';
import 'package:production/src/features/Job/screens/job_list_screen.dart';
import 'package:production/src/features/Orders/screens/add_order_page.dart';
import 'package:production/src/features/PurchaseOrder/controllers/add_po.dart';
import 'package:production/src/features/PurchaseOrder/screnns/AddPurchaseOrder.dart';
import 'package:production/src/features/PurchaseOrder/screnns/po_list.dart';
import 'package:production/src/features/ShiftPlan/screens/shift_plan_create.dart';
import 'package:production/src/features/Warping/screens/warping_list.dart';
import 'package:production/src/features/authentication/screens/home.dart';
import 'package:production/src/features/authentication/screens/login.dart';
import 'package:production/src/features/customer/screens/AddCustomer.dart';
import 'package:production/src/features/customer/screens/customerList.dart';
import 'package:production/src/features/elastic/screens/addElastic.dart';
import 'package:production/src/features/elastic/screens/elastic_list_page.dart';
import 'package:production/src/features/materials/screens/add_materials_page.dart';
import 'package:production/src/features/packing/screens/AddPacking.dart';
import 'package:production/src/features/supplier/screen/supplier_list_page.dart';
import 'package:production/src/features/wastage/screens/Add_Wastage.dart';

import '../../Orders/screens/order_list_page.dart';
import '../../PurchaseOrder/screnns/add_po.dart';
import '../../materials/screens/material_list_screenn.dart';
import '../../packing/screens/PackingOverview.dart';
import '../../shift/screens/shift_list_page.dart';

// impor

class MoreOptionsPage extends StatelessWidget {
  const MoreOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("More")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _OptionTile(
              icon: Icons.people,
              label: "Customers",
              onTap: () => Get.to(() => CustomerListPage()),
            ),
            _OptionTile(
              icon: Icons.shopping_bag,
              label: "Supplier",
              onTap: () => Get.to(() => SupplierListPage()),
            ),
            _OptionTile(
              icon: Icons.linear_scale,
              label: "Elastics",
              onTap: () => Get.to(() => ElasticListPage()),
            ),
            _OptionTile(
              icon: Icons.inventory_2,
              label: "Raw Material",
              onTap: () => Get.to(() => RawMaterialListPage()),
            ),
            _OptionTile(
              icon: Icons.note_add,
              label: "Orders",
              onTap: () => Get.to(() => OrderListPage()),
            ),
            _OptionTile(
              icon: Icons.military_tech,
              label: "Jobs",
              onTap: () => Get.to(() => JobListPage()),
            ),
            _OptionTile(
              icon: Icons.transfer_within_a_station,
              label: "Add Wastage",
              onTap: () => Get.to(() => AddWastagePage()),
            ),
            _OptionTile(
              icon: Icons.next_plan,
              label: "Create Shift Plan",
              onTap: () => Get.to(() => CreateShiftPlanPage()),
            ),
            _OptionTile(
              icon: Icons.check_box,
              label: "Packing",
              onTap: () => Get.to(() => const Home()),
            ),
            _OptionTile(
              icon: Icons.precision_manufacturing,
              label: "Machines",
              onTap: () => Get.to(() => const Home()),
            ),
            _OptionTile(
              icon: Icons.badge,
              label: "Employees",
              onTap: () => Get.to(() => const Home()),
            ),
            _OptionTile(
              icon: Icons.surround_sound_rounded,
              label: "Covering",
              onTap: () => Get.to(() => CoveringListPage()),
            ),
            _OptionTile(
              icon: Icons.wrap_text_sharp,
              label: "Warping",
              onTap: () => Get.to(() => WarpingListPage()),
            ),
            _OptionTile(
              icon: Icons.transit_enterexit,
              label: "Open Shift Production",
              onTap: () => Get.to(() => ShiftListPage()),
            ),
            _OptionTile(
              icon: Icons.backpack,
              label: "Add Packing Details",
              onTap: () => Get.to(() => PackagingOverviewPage()),
            ),
            _OptionTile(
              icon: Icons.backpack,
              label: "Add Purchase Order",
              onTap: () => Get.to(() => AddPOPage(mode: POFormMode.create,)),
            ),
            _OptionTile(
              icon: Icons.backpack,
              label: " Purchase Order",
              onTap: () => Get.to(() => POListPage()),
            ),
            _OptionTile(
              icon: Icons.logout,
              label: "Material Inward",
              isDanger: true,
              onTap: () => Get.to(() => AddPOPage(mode: POFormMode.create,)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          // TODO: clear token / storage
          Get.offAll(() => const Login());
        },
        child: const Text("Logout"),
      ),
      cancel: TextButton(onPressed: Get.back, child: const Text("Cancel")),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDanger ? Colors.red : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isDanger ? Colors.red : Colors.blueGrey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDanger ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
