class LocationModel {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String? state;
  final bool isFavorite;

  LocationModel({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
    this.isFavorite = false,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? '',
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      country: json['country'] ?? '',
      state: json['state'],
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
      'country': country,
      'state': state,
      'is_favorite': isFavorite,
    };
  }

  LocationModel copyWith({
    String? name,
    double? lat,
    double? lon,
    String? country,
    String? state,
    bool? isFavorite,
  }) {
    return LocationModel(
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      country: country ?? this.country,
      state: state ?? this.state,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  String get displayName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }
}
