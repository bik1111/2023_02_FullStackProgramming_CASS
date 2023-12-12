class Cafe {
  final String cafe_id; // Keep it as String if needed
  final String name;
  final String address;
  final String number;
  final double latitude; // Change to double
  final double longitude; // Change to double

  Cafe({
    required this.cafe_id,
    required this.name,
    required this.address,
    required this.number,
    required this.latitude,
    required this.longitude,
  });

  // Existing code...

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      cafe_id: json['cafe_id'].toString() ?? 'N/A', // Keep it as String if needed
      name: json['name'] ?? 'N/A',
      address: json['address'] as String ?? 'N/A',
      number: json['number'].toString() ?? 'N/A',
      latitude: json['lat'] != null ? double.tryParse(json['lat'].toString()) ?? 0.0 : 0.0,
      longitude: json['lng'] != null ? double.tryParse(json['lng'].toString()) ?? 0.0 : 0.0,
    );
  }
}
