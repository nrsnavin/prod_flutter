class MachineCreate {
  final String machineId;
  final String manufacturer;
  final int noOfHeads;
  final int noOfHooks;
  final String elastics;

  MachineCreate({
    required this.machineId,
    required this.manufacturer,
    required this.noOfHeads,
    required this.noOfHooks,
    required this.elastics,
  });

  Map<String, dynamic> toJson() {
    return {
      'ID': machineId,
      'manufacturer': manufacturer,
      'NoOfHead': noOfHeads,
      'NoOfHooks': noOfHooks,
      'elastics': elastics,
    };
  }
}
