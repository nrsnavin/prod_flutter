import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/editCustomerController.dart';


class EditCustomerPage extends StatelessWidget {
  final Map customer;

  const EditCustomerPage({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.put(EditCustomerController(customer: customer));

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Customer")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _text("Customer Name *", controller.nameCtrl),
              _text("Email *", controller.emailCtrl,
                  keyboard: TextInputType.emailAddress),
              _text("GSTIN", controller.gstinCtrl),

              _statusDropdown(controller),

              _text("Contact Name *", controller.contactNameCtrl),
              _text("Phone Number *", controller.phoneCtrl,
                  keyboard: TextInputType.phone),

              _paymentTermsDropdown(controller),

              const SizedBox(height: 24),

              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.loading.value
                      ? null
                      : controller.updateCustomer,
                  child: controller.loading.value
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : const Text("Update Customer"),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _text(String label, TextEditingController ctrl,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        validator: (v) =>
        label.contains("*") && (v == null || v.isEmpty)
            ? "Required"
            : null,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _statusDropdown(EditCustomerController controller) {
    return Obx(() => DropdownButtonFormField<String>(
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
    ));
  }

  Widget _paymentTermsDropdown(EditCustomerController controller) {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.paymentTerms.value,
      items: const [
        DropdownMenuItem(value: "Advance", child: Text("Advance")),
        DropdownMenuItem(value: "15", child: Text("15 Days")),
        DropdownMenuItem(value: "30", child: Text("30 Days")),
        DropdownMenuItem(value: "45", child: Text("45 Days")),
        DropdownMenuItem(value: "60", child: Text("60 Days")),
      ],
      onChanged: (v) => controller.paymentTerms.value = v!,
      decoration: const InputDecoration(
        labelText: "Payment Terms",
        border: OutlineInputBorder(),
      ),
    ));
  }
}
