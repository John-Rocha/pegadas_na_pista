enum WildlifeRecordType {
  roadkill,
  sighting;

  String get apiValue => switch (this) {
    WildlifeRecordType.roadkill => 'atropelamento',
    WildlifeRecordType.sighting => 'avistamento',
  };
}
