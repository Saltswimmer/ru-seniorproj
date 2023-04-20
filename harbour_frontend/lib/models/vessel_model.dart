class Vessel {

  final String vessel_id;
  final String name;

  const Vessel({
    required this.vessel_id,
    required this.name,
  });

  factory Vessel.fromJson(Map json) {
    return Vessel(
      vessel_id: json['id'],
      name: json['name'],
    );
  }

  Map toJson() => {
    'Vessel': vessel_id,
    'Id': name,
  };
}