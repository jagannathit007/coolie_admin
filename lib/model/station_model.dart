
class StationListData {
  final Stations stations;

  StationListData({
    required this.stations,
  });

  factory StationListData.fromJson(Map<String, dynamic> json) {
    return StationListData(
      stations: Stations.fromJson(json['stations']),
    );
  }
}

class Stations {
  final List<Station> docs;
  final String totalDocs;
  final String limit;
  final String totalPages;
  final String page;
  final String pagingCounter;
  final bool hasPrevPage;
  final bool hasNextPage;
  final dynamic prevPage;
  final dynamic nextPage;

  Stations({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    required this.prevPage,
    required this.nextPage,
  });

  factory Stations.fromJson(Map<String, dynamic> json) {
    return Stations(
      docs: (json['docs'] as List<dynamic>)
          .map((item) => Station.fromJson(item))
          .toList(),
      totalDocs: json['totalDocs']?.toString() ?? '0',
      limit: json['limit']?.toString() ?? '0',
      totalPages: json['totalPages']?.toString() ?? '0',
      page: json['page']?.toString() ?? '1',
      pagingCounter: json['pagingCounter']?.toString() ?? '1',
      hasPrevPage: json['hasPrevPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
      prevPage: json['prevPage'],
      nextPage: json['nextPage'],
    );
  }
}

class Station {
  final String id;
  final String name;
  final String code;
  final String cityId;
  final String address;
  final String platforms;
  final String? latitude;
  final String? longitude;
  final String geofenceRadius;
  final List<List<List<String>>>? geofencePolygon;
  final bool isActive;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final String version;
  final GeofenceConfig geofenceConfig;

  Station({
    required this.id,
    required this.name,
    required this.code,
    required this.cityId,
    required this.address,
    required this.platforms,
    this.latitude,
    this.longitude,
    required this.geofenceRadius,
    this.geofencePolygon,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.geofenceConfig,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      cityId: json['cityId'] ?? '',
      address: json['address'] ?? '',
      platforms: json['platforms']?.toString() ?? '0',
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      geofenceRadius: json['geofenceRadius']?.toString() ?? '0',
      geofencePolygon: json['geofencePolygon'] != null 
          ? List<List<List<String>>>.from(json['geofencePolygon'].map(
              (polygon) => List<List<String>>.from(polygon.map(
                (point) => List<String>.from(point.map((coord) => coord.toString()))
              ))
            ))
          : null,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      version: json['__v']?.toString() ?? '0',
      geofenceConfig: GeofenceConfig.fromJson(json['geofenceConfig'] ?? {}),
    );
  }
}

class GeofenceConfig {
  final String geofenceType;
  final String area;
  final String vertices;

  GeofenceConfig({
    required this.geofenceType,
    required this.area,
    required this.vertices,
  });

  factory GeofenceConfig.fromJson(Map<String, dynamic> json) {
    return GeofenceConfig(
      geofenceType: json['geofenceType'] ?? '',
      area: json['area']?.toString() ?? '0',
      vertices: json['vertices']?.toString() ?? '0',
    );
  }
}