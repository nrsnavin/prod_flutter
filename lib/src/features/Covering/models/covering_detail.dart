class ElasticTechnical {
  final String id;
  final String name;

  final WarpSpandex warpSpandex;
  final CoveringSpandex covering;
  final TestingParams testing;

  ElasticTechnical({
    required this.id,
    required this.name,
    required this.warpSpandex,
    required this.covering,
    required this.testing,
  });

  factory ElasticTechnical.fromJson(Map<String, dynamic> json) {
    return ElasticTechnical(
      id: json["_id"],
      name: json["name"],
      warpSpandex: WarpSpandex.fromJson(json["warpSpandex"]),
      covering: CoveringSpandex.fromJson(json["spandexCovering"]),
      testing: TestingParams.fromJson(json["testingParameters"]),
    );
  }
}


class WarpSpandex {
  final String materialName;
  final int ends;

  WarpSpandex({
    required this.materialName,
    required this.ends,
  });

  factory WarpSpandex.fromJson(Map<String, dynamic> json) {
    return WarpSpandex(
      materialName: json["id"]["name"],
      ends: json["ends"] ?? 0,
    );
  }
}


class CoveringSpandex {
  final String materialName;
  final double weight;

  CoveringSpandex({
    required this.materialName,
    required this.weight,
  });

  factory CoveringSpandex.fromJson(Map<String, dynamic> json) {
    return CoveringSpandex(
      materialName: json["id"]["name"],
      weight: (json["weight"] ?? 0).toDouble(),
    );
  }
}


class TestingParams {
  final double? width;
  final int elongation;
  final int recovery;

  TestingParams({
    this.width,
    required this.elongation,
    required this.recovery,
  });

  factory TestingParams.fromJson(Map<String, dynamic> json) {
    return TestingParams(
      width: json["width"]?.toDouble(),
      elongation: json["elongation"] ?? 0,
      recovery: json["recovery"] ?? 0,
    );
  }
}


class CoveringElasticDetail {
  final ElasticTechnical elastic;
  final int quantity;

  CoveringElasticDetail({
    required this.elastic,
    required this.quantity,
  });

  factory CoveringElasticDetail.fromJson(Map<String, dynamic> json) {
    return CoveringElasticDetail(
      elastic: ElasticTechnical.fromJson(json["elastic"]),
      quantity: json["quantity"],
    );
  }
}


class JobSummary {
  final String id;
  final int jobOrderNo;
  final String status;
  final String? customerName;

  JobSummary({
    required this.id,
    required this.jobOrderNo,
    required this.status,
    this.customerName,
  });

  factory JobSummary.fromJson(Map<String, dynamic> json) {
    return JobSummary(
      id: json["_id"],
      jobOrderNo: json["jobOrderNo"],
      status: json["status"],
      customerName: json["customer"]?["name"],
    );
  }
}



