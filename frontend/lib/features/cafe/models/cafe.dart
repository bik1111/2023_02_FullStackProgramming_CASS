class Cafe {
  final int cafe_id;
  final String name;
  final String address;
  final String number;
  final String latitude; // Add this line
  final String longitude; // Add this line

  Cafe({
    required this.cafe_id,
    required this.name,
    required this.address,
    required this.number,
    required this.latitude, // Add this line
    required this.longitude, // Add this line
  });

  // Existing code...

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      cafe_id: json['cafe_id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      number: json['number'] ?? '',
      latitude: json['lat'] ?? 0.0, // Adjust based on your API response
      longitude: json['lng'] ?? 0.0, // Adjust based on your API response
    );
  }
}

