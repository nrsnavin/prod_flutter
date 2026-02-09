class BeamPlan {
  int beamNo;
  List<BeamSection> sections;

  BeamPlan({
    required this.beamNo,
    required this.sections,
  });

  int get totalEnds =>
      sections.fold(0, (sum, s) => sum + s.ends);
}


class BeamSection {
  String? warpYarnId;
  String? warpYarnName;
  int ends;

  BeamSection({
    this.warpYarnId,
    this.warpYarnName,
    this.ends = 0,
  });
}
