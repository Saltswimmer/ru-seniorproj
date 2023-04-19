class Vessel {
  final String name;
  final String id;

  const Vessel({
    required this.name,
    required this.id
  });

  factory Vessel.fromJson(Map json) {
    return Vessel(
      name: json['name'],
      id: json['id']
    );
  }

  Map toJson() => {
    'name': name,
    'id': id
  };
}
