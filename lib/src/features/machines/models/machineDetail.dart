class Machine {
  final String machineId;
  final String manufacturer;
  final int noOfHeads;
  final int noOfHooks;
  final String currentOrder;
  final String status; // RUNNING / FREE

  Machine({
    required this.machineId,
    required this.manufacturer,
    required this.noOfHeads,
    required this.noOfHooks,
    required this.currentOrder,
    required this.status,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      machineId: json['machineId'],
      manufacturer: json['manufacturer'],
      noOfHeads: json['noOfHeads'],
      noOfHooks: json['noOfHooks'],
      currentOrder: json['currentOrder'],
      status: json['status'],
    );
  }
}
