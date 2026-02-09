import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customerController.dart';


class AddCustomerPage extends StatelessWidget {
  AddCustomerPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final CustomerController controller = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Customer"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Basic Details"),
              _text("Customer Name *", controller.nameCtrl),
              _text(
                "Email *",
                controller.emailCtrl,
                keyboard: TextInputType.emailAddress,
              ),
              _text("GSTIN", controller.gstinCtrl),

              _statusDropdown(),

              const SizedBox(height: 16),

              _sectionTitle("Primary Contact"),
              _text("Contact Name *", controller.contactNameCtrl),
              _text(
                "Phone Number *",
                controller.phoneCtrl,
                keyboard: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              _sectionTitle("Purchase Contact"),
              _contactBlock(
                nameCtrl: controller.purchaseNameCtrl,
                mobileCtrl: controller.purchaseMobileCtrl,
                emailCtrl: controller.purchaseEmailCtrl,
              ),

              const SizedBox(height: 16),

              _sectionTitle("Accounts Contact"),
              _contactBlock(
                nameCtrl: controller.accountNameCtrl,
                mobileCtrl: controller.accountMobileCtrl,
                emailCtrl: controller.accountEmailCtrl,
              ),

              const SizedBox(height: 16),

              _sectionTitle("Merchandiser Contact"),
              _contactBlock(
                nameCtrl: controller.merchantNameCtrl,
                mobileCtrl: controller.merchantMobileCtrl,
                emailCtrl: controller.merchantEmailCtrl,
              ),

              const SizedBox(height: 16),

              _sectionTitle("Commercial"),
              _paymentTermsDropdown(),

              const SizedBox(height: 24),

              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.loading.value
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      controller.submitCustomer();
                    }
                  },
                  child: controller.loading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text("Save Customer"),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _text(
      String label,
      TextEditingController ctrl, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        validator: (v) =>
        label.contains("*") && (v == null || v.isEmpty)
            ? "Required"
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _statusDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Obx(() => DropdownButtonFormField<String>(
        value: controller.status.value,
        items: const [
          DropdownMenuItem(value: "Active", child: Text("Active")),
          DropdownMenuItem(value: "Inactive", child: Text("Inactive")),
        ],
        onChanged: (v) => controller.status.value = v!,
        decoration: const InputDecoration(
          labelText: "Status",
          border: OutlineInputBorder(),
        ),
      )),
    );
  }

  Widget _paymentTermsDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Obx(() => DropdownButtonFormField<String>(
        value: controller.paymentTerms.value,
        items: const [
          DropdownMenuItem(value: "Advance", child: Text("Advance")),
          DropdownMenuItem(value: "15", child: Text("15 Days")),
          DropdownMenuItem(value: "30", child: Text("30 Days")),
          DropdownMenuItem(value: "45", child: Text("45 Days")),
          DropdownMenuItem(value: "60", child: Text("60 Days")),
        ],
        onChanged: (v) => controller.paymentTerms.value = v!,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: const InputDecoration(
          labelText: "Payment Terms *",
          border: OutlineInputBorder(),
        ),
      )),
    );
  }

  Widget _contactBlock({
    required TextEditingController nameCtrl,
    required TextEditingController mobileCtrl,
    required TextEditingController emailCtrl,
  }) {
    return Column(
      children: [
        _text("Name", nameCtrl),
        _text("Mobile", mobileCtrl, keyboard: TextInputType.phone),
        _text("Email", emailCtrl, keyboard: TextInputType.emailAddress),
      ],
    );
  }
}
