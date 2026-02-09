class WarpingBeamSection {

  final String warpYarnId;
  final String warpYarnName; // populated
  final int ends;

  WarpingBeamSection({

    required this.warpYarnId,
    required this.warpYarnName,
    required this.ends,
  });

  factory WarpingBeamSection.fromJson(Map<String, dynamic> json) {
    return WarpingBeamSection(

      warpYarnId: json['warpYarn'] is Map
          ? json['warpYarn']['_id']
          : json['warpYarn'],
      warpYarnName: json['warpYarn'] is Map
          ? json['warpYarn']['name']
          : '',
      ends: json['ends'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "sectionNo": sectionNo,
      "warpYarn": warpYarnId,
      "ends": ends,
    };
  }
}


class WarpingBeam {
  final int beamNo;
  final List<WarpingBeamSection> sections;
  final int totalEnds;

  WarpingBeam({
    required this.beamNo,
    required this.sections,
    required this.totalEnds,
  });

  factory WarpingBeam.fromJson(Map<String, dynamic> json) {
    return WarpingBeam(
      beamNo: json['beamNo'],
      totalEnds: json['totalEnds'],
      sections: (json['sections'] as List)
          .map((e) => WarpingBeamSection.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "beamNo": beamNo,
      "totalEnds": totalEnds,
      "sections": sections.map((e) => e.toJson()).toList(),
    };
  }
}
class WarpingPlanModel {
  final String id;
  final String warpingId;
  final String jobId;
  final int noOfBeams;
  final List<WarpingBeam> beams;
  final String? remarks;
  final DateTime createdAt;

  WarpingPlanModel({
    required this.id,
    required this.warpingId,
    required this.jobId,
    required this.noOfBeams,
    required this.beams,
    this.remarks,
    required this.createdAt,
  });

  factory WarpingPlanModel.fromJson(Map<String, dynamic> json) {
    return WarpingPlanModel(
      id: json['_id'],
      warpingId: json['warping'],
      jobId: json['job'] is Map
          ? json['job']['_id']
          : json['job'],
      noOfBeams: json['beamCount'],
      remarks: "",
      createdAt: DateTime.parse(json['createdAt']),
      beams: (json['beams'] as List)
          .map((e) => WarpingBeam.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "warpingId": warpingId,
      "job": jobId,
      "noOfBeams": noOfBeams,
      "remarks": remarks,
      "beams": beams.map((e) => e.toJson()).toList(),
    };
  }
}


