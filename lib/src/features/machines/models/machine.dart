class MachineList {
  String id;
  String ID;
  String manufacturer;
  int jacquardHooks;
  int heads;
  String elastic;
  String status;
  var operator;

  MachineList({
    required this.id,
    required this.ID,
    required this.status,
    required this.manufacturer,
    required this.jacquardHooks,
    required this.heads,
    required this.elastic,
  });

  factory MachineList.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        '_id': String id,
        'ID': String ID,
        'manufacturer': String manufacturer,
        'NoOfHead': int NoOfHead,
        'NoOfHooks': int NoOfHooks,
        'elastics': String elastic,
        'status': String status,
      } =>
        MachineList(
          id: id,
          ID: ID,
          manufacturer: manufacturer,
          heads: NoOfHead,
          jacquardHooks: NoOfHooks,
          status: status,
          elastic: elastic,
        ),
      _ => throw const FormatException('Failed to load Job.'),
    };
  }
}
