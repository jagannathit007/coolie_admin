class AddCoolieResponse {
  final CollieData? collie;
  final FaceRegistration? faceRegistration;

  AddCoolieResponse({
    this.collie,
    this.faceRegistration,
  });

  factory AddCoolieResponse.fromJson(Map<String, dynamic> json) {
    return AddCoolieResponse(
      collie: json['collie'] != null ? CollieData.fromJson(json['collie']) : null,
      faceRegistration: json['faceRegistration'] != null 
          ? FaceRegistration.fromJson(json['faceRegistration']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collie': collie?.toJson(),
      'faceRegistration': faceRegistration?.toJson(),
    };
  }
}

class CollieData {
  final String? id;
  final String? name;
  final String? mobileNo;
  final String? buckleNumber;
  final String? stationId;
  final bool? isApproved;
  final bool? faceRegistered;
  final String? faceEmbeddingId;

  CollieData({
    this.id,
    this.name,
    this.mobileNo,
    this.buckleNumber,
    this.stationId,
    this.isApproved,
    this.faceRegistered,
    this.faceEmbeddingId,
  });

  factory CollieData.fromJson(Map<String, dynamic> json) {
    return CollieData(
      id: json['_id'],
      name: json['name'],
      mobileNo: json['mobileNo'],
      buckleNumber: json['buckleNumber'],
      stationId: json['stationId'],
      isApproved: json['isApproved'],
      faceRegistered: json['faceRegistered'],
      faceEmbeddingId: json['faceEmbeddingId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'mobileNo': mobileNo,
      'buckleNumber': buckleNumber,
      'stationId': stationId,
      'isApproved': isApproved,
      'faceRegistered': faceRegistered,
      'faceEmbeddingId': faceEmbeddingId,
    };
  }
}

class FaceRegistration {
  final String? filename;
  final String? s3Url;
  final bool? processed;
  final bool? embeddingStored;
  final String? error;

  FaceRegistration({
    this.filename,
    this.s3Url,
    this.processed,
    this.embeddingStored,
    this.error,
  });

  factory FaceRegistration.fromJson(Map<String, dynamic> json) {
    return FaceRegistration(
      filename: json['filename'],
      s3Url: json['s3_url'],
      processed: json['processed'],
      embeddingStored: json['embedding_stored'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      's3_url': s3Url,
      'processed': processed,
      'embedding_stored': embeddingStored,
      'error': error,
    };
  }
}
