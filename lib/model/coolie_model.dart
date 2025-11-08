class CoolieListData {
  final List<Coolie> docs;
  final String totalDocs;
  final String limit;
  final String totalPages;
  final String page;
  final String pagingCounter;
  final bool hasPrevPage;
  final bool hasNextPage;
  final dynamic prevPage;
  final dynamic nextPage;

  CoolieListData({
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

  factory CoolieListData.fromJson(Map<String, dynamic> json) {
    return CoolieListData(
      docs: (json['docs'] as List<dynamic>)
          .map((item) => Coolie.fromJson(item))
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

class Coolie {
  final String id;
  final String name;
  final String mobileNo;
  final String age;
  final String deviceType;
  final String emailId;
  final String gender;
  final String buckleNumber;
  final Station stationId;
  final String address;
  final String deviceId;
  final String faceEmbeddingId;
  final bool isApproved;
  final bool isActive;
  final bool isLoggedIn;
  final String? lastLoginTime;
  final String fcm;
  final double? latitude;
  final double? longitude;
  final String? currentBookingId;
  final String rating;
  final String totalRatings;
  final String completedBookings;
  final String rejectedBookings;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final String version;
  final CoolieImage image;
  final RateCard rateCard;

  Coolie({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.age,
    required this.deviceType,
    required this.emailId,
    required this.gender,
    required this.buckleNumber,
    required this.stationId,
    required this.address,
    required this.deviceId,
    required this.faceEmbeddingId,
    required this.isApproved,
    required this.isActive,
    required this.isLoggedIn,
    this.lastLoginTime,
    required this.fcm,
    this.latitude,
    this.longitude,
    this.currentBookingId,
    required this.rating,
    required this.totalRatings,
    required this.completedBookings,
    required this.rejectedBookings,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.image,
    required this.rateCard,
  });

  factory Coolie.fromJson(Map<String, dynamic> json) {
    return Coolie(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      age: json['age']?.toString() ?? '',
      deviceType: json['deviceType'] ?? '',
      emailId: json['emailId'] ?? '',
      gender: json['gender'] ?? '',
      buckleNumber: json['buckleNumber'] ?? '',
      stationId: Station.fromJson(json['stationId'] ?? {}),
      address: json['address']?.toString() ?? '',
      deviceId: json['deviceId'] ?? '',
      faceEmbeddingId: json['faceEmbeddingId'] ?? '',
      isApproved: json['isApproved'] ?? false,
      isActive: json['isActive'] ?? false,
      isLoggedIn: json['isLoggedIn'] ?? false,
      lastLoginTime: json['lastLoginTime'],
      fcm: json['fcm'] ?? '',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      currentBookingId: json['currentBookingId'],
      rating: json['rating']?.toString() ?? '0',
      totalRatings: json['totalRatings']?.toString() ?? '0',
      completedBookings: json['completedBookings']?.toString() ?? '0',
      rejectedBookings: json['rejectedBookings']?.toString() ?? '0',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      version: json['__v']?.toString() ?? '0',
      image: CoolieImage.fromJson(json['image'] ?? {}),
      rateCard: RateCard.fromJson(json['rateCard'] ?? {}),
    );
  }
}

class CoolieImage {
  final String url;
  final String s3Key;

  CoolieImage({
    required this.url,
    required this.s3Key,
  });

  factory CoolieImage.fromJson(Map<String, dynamic> json) {
    return CoolieImage(
      url: json['url'] ?? '',
      s3Key: json['s3Key'] ?? '',
    );
  }
}

class RateCard {
  final String baseRate;
  final String baseTime;
  final String waitingRate;

  RateCard({
    required this.baseRate,
    required this.baseTime,
    required this.waitingRate,
  });

  factory RateCard.fromJson(Map<String, dynamic> json) {
    return RateCard(
      baseRate: json['baseRate']?.toString() ?? '0',
      baseTime: json['baseTime']?.toString() ?? '0',
      waitingRate: json['waitingRate']?.toString() ?? '0',
    );
  }
}

class Station {
  final String id;
  final String name;

  Station({
    required this.id,
    required this.name,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}