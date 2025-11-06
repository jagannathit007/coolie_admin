class StationListResponse {
  final List<Station> station;

  StationListResponse({required this.station});

  factory StationListResponse.fromJson(Map<String, dynamic> json) {
    return StationListResponse(station: (json['station'] as List).map((stationJson) => Station.fromJson(stationJson)).toList());
  }

  Map<String, dynamic> toJson() {
    return {'station': station.map((station) => station.toJson()).toList()};
  }
}

class Station {
  final GeofenceConfig geofenceConfig;
  final String id;
  final String name;
  final String code;
  final String cityId;
  final String address;
  final String? latitude;
  final String? longitude;
  final String geofenceRadius;
  final List<List<List<String>>>? geofencePolygon;
  final bool isActive;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final String v;
  final String? platforms;

  Station({
    required this.geofenceConfig,
    required this.id,
    required this.name,
    required this.code,
    required this.cityId,
    required this.address,
    this.latitude,
    this.longitude,
    required this.geofenceRadius,
    this.geofencePolygon,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.platforms,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      geofenceConfig: GeofenceConfig.fromJson(json['geofenceConfig']),
      id: json['_id'],
      name: json['name'],
      code: json['code'],
      cityId: json['cityId'],
      address: json['address'] ?? '',
      latitude: json['latitude'],
      longitude: json['longitude'],
      geofenceRadius: json['geofenceRadius'],
      geofencePolygon: json['geofencePolygon'] != null
          ? List<List<List<String>>>.from(
              json['geofencePolygon']?.map(
                (polygon) => List<List<String>>.from(polygon.map((vertex) => List<String>.from(vertex.map((coord) => coord.toString())))),
              ),
            )
          : null,
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      platforms: json['platforms'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'geofenceConfig': geofenceConfig.toJson(),
      '_id': id,
      'name': name,
      'code': code,
      'cityId': cityId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'geofenceRadius': geofenceRadius,
      'geofencePolygon': geofencePolygon,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'platforms': platforms,
    };
  }
}

class GeofenceConfig {
  final String geofenceType;
  final String area;
  final String vertices;

  GeofenceConfig({required this.geofenceType, required this.area, required this.vertices});

  factory GeofenceConfig.fromJson(Map<String, dynamic> json) {
    return GeofenceConfig(geofenceType: json['geofenceType'], area: json['area'], vertices: json['vertices']);
  }

  Map<String, dynamic> toJson() {
    return {'geofenceType': geofenceType, 'area': area, 'vertices': vertices};
  }
}
