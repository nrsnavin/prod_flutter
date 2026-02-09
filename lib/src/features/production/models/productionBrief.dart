class ProductionBrief {
  String date;
  int production;

  ProductionBrief({required this.date, required this.production});

  factory ProductionBrief.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'date': String date,
        'production': int production,
      } =>
        ProductionBrief(date: date, production: production),
      _ => throw const FormatException('Failed to load Job.'),
    };
  }
}
