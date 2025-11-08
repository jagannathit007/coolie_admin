class PassengerListData {
  final List<Passenger> docs;
  final String totalDocs;
  final String limit;
  final String totalPages;
  final String page;
  final String pagingCounter;
  final bool hasPrevPage;
  final bool hasNextPage;
  final dynamic prevPage;
  final dynamic nextPage;

  PassengerListData({
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

  factory PassengerListData.fromJson(Map<String, dynamic> json) {
    return PassengerListData(
      docs: (json['docs'] as List<dynamic>)
          .map((item) => Passenger.fromJson(item))
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

class Passenger {
  final String id;
  final String name;
  final String mobileNo;
  final String emailId;
  final String userImage;
  final bool isActive;
  final String deviceId;
  final bool isVerified;
  final String gender;
  final String fcm;
  final bool isDeleted;
  final String latitude;
  final String longitude;
  final String otp;
  final String createdAt;
  final String updatedAt;
  final String version;
  final AddressComponent addressComponent;

  Passenger({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.emailId,
    required this.userImage,
    required this.isActive,
    required this.deviceId,
    required this.isVerified,
    required this.gender,
    required this.fcm,
    required this.isDeleted,
    required this.latitude,
    required this.longitude,
    required this.otp,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.addressComponent,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      emailId: json['emailId'] ?? '',
      userImage: json['userImage'] ?? '',
      isActive: json['isActive'] ?? false,
      deviceId: json['deviceId'] ?? '',
      isVerified: json['isVerified'] ?? false,
      gender: json['gender'] ?? '',
      fcm: json['fcm'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      latitude: json['latitude']?.toString() ?? '0',
      longitude: json['longitude']?.toString() ?? '0',
      otp: json['otp'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      version: json['__v']?.toString() ?? '0',
      addressComponent: AddressComponent.fromJson(json['addressComponent'] ?? {}),
    );
  }
}

class AddressComponent {
  final String pincode;
  final String city;
  final String state;

  AddressComponent({
    required this.pincode,
    required this.city,
    required this.state,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      pincode: json['pincode'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }

  // Helper method to get formatted address
  String get formattedAddress {
    List<String> parts = [];
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (pincode.isNotEmpty) parts.add(pincode);
    
    return parts.isEmpty ? 'No address provided' : parts.join(', ');
  }
}