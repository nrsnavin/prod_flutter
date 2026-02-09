import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/machine_controller.dart';
import '../models/MachineCreate.dart';


class AddMachinePage extends StatefulWidget {
  const AddMachinePage({super.key});

  @override
  State<AddMachinePage> createState() => _AddMachinePageState();
}

class _AddMachinePageState extends State<AddMachinePage> {

  final machineController = Get.put(MachineController());
  final _formKey = GlobalKey<FormState>();

  final _machineIdCtrl = TextEditingController();
  final _manufacturerCtrl = TextEditingController();
  final _headsCtrl = TextEditingController();
  final _hooksCtrl = TextEditingController();
  final _elasticsCtrl = TextEditingController();

  @override
  void dispose() {
    _machineIdCtrl.dispose();
    _manufacturerCtrl.dispose();
    _headsCtrl.dispose();
    _hooksCtrl.dispose();
    _elasticsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final machine = MachineCreate(
      machineId: _machineIdCtrl.text.trim(),
      manufacturer: _manufacturerCtrl.text.trim(),
      noOfHeads: int.parse(_headsCtrl.text),
      noOfHooks: int.parse(_hooksCtrl.text),
      elastics: _elasticsCtrl.text.trim(),
    );
   machineController.addMachine(machine);
    // 🔌 API call will go here
    // ApiService.post('/machines', machine.toJson());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Machine')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _textField(
                controller: _machineIdCtrl,
                label: 'Machine ID',
                hint: 'LOOM-EL-01',
              ),
              _textField(
                controller: _manufacturerCtrl,
                label: 'Manufacturer',
                hint: 'Lohia Corp',
              ),
              _numberField(
                controller: _headsCtrl,
                label: 'No. of Heads',
              ),
              _numberField(
                controller: _hooksCtrl,
                label: 'No. of Hooks',
              ),
              _textField(
                controller: _elasticsCtrl,
                label: 'Elastics',
                hint: 'Polyester / Nylon',
              ),
              const SizedBox(height: 24),

              Obx(() {

                return ElevatedButton(
                  onPressed: machineController.isSaving.value ? null : _submit,
                  child: machineController.isSaving.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text(
                    'ADD EMPLOYEE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }),

            ],
          ),
        ),
      ),
    );
  }

  // 🔹 TEXT FIELD
  Widget _textField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
        value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }

  // 🔹 NUMBER FIELD
  Widget _numberField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          if (int.tryParse(value) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}
