class DashboardStats {
  final Overview overview;
  final List<StationStat> stationStats;
  final List<dynamic> trends;
  final List<Performance> performance;

  DashboardStats({
    required this.overview,
    required this.stationStats,
    required this.trends,
    required this.performance,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      overview: Overview.fromJson(json['overview']),
      stationStats: (json['stationStats'] as List<dynamic>)
          .map((item) => StationStat.fromJson(item))
          .toList(),
      trends: json['trends'] ?? [],
      performance: (json['performance'] as List<dynamic>)
          .map((item) => Performance.fromJson(item))
          .toList(),
    );
  }
}

class Overview {
  final TotalBookings totalBookings;
  final CompletedBookings completedBookings;
  final String totalStations;
  final ActiveCollies activeCollies;
  final TotalUsers totalUsers;
  final TotalRevenue totalRevenue;
  final String completionRate;
  final String averageRating;

  Overview({
    required this.totalBookings,
    required this.completedBookings,
    required this.totalStations,
    required this.activeCollies,
    required this.totalUsers,
    required this.totalRevenue,
    required this.completionRate,
    required this.averageRating,
  });

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      totalBookings: TotalBookings.fromJson(json['totalBookings']),
      completedBookings: CompletedBookings.fromJson(json['completedBookings']),
      totalStations: json['totalStations']?.toString() ?? '0',
      activeCollies: ActiveCollies.fromJson(json['activeCollies']),
      totalUsers: TotalUsers.fromJson(json['totalUsers']),
      totalRevenue: TotalRevenue.fromJson(json['totalRevenue']),
      completionRate: json['completionRate']?.toString() ?? '0',
      averageRating: json['averageRating']?.toString() ?? '0',
    );
  }
}

class TotalBookings {
  final String count;
  final String averageFare;

  TotalBookings({
    required this.count,
    required this.averageFare,
  });

  factory TotalBookings.fromJson(Map<String, dynamic> json) {
    return TotalBookings(
      count: json['count']?.toString() ?? '0',
      averageFare: json['averageFare']?.toString() ?? '0',
    );
  }
}

class CompletedBookings {
  final String count;
  final String totalRevenue;
  final String averageRating;

  CompletedBookings({
    required this.count,
    required this.totalRevenue,
    required this.averageRating,
  });

  factory CompletedBookings.fromJson(Map<String, dynamic> json) {
    return CompletedBookings(
      count: json['count']?.toString() ?? '0',
      totalRevenue: json['totalRevenue']?.toString() ?? '0',
      averageRating: json['averageRating']?.toString() ?? '0',
    );
  }
}

class ActiveCollies {
  final String total;
  final String active;
  final String available;

  ActiveCollies({
    required this.total,
    required this.active,
    required this.available,
  });

  factory ActiveCollies.fromJson(Map<String, dynamic> json) {
    return ActiveCollies(
      total: json['total']?.toString() ?? '0',
      active: json['active']?.toString() ?? '0',
      available: json['available']?.toString() ?? '0',
    );
  }
}

class TotalUsers {
  final String total;
  final String verified;
  final String active;

  TotalUsers({
    required this.total,
    required this.verified,
    required this.active,
  });

  factory TotalUsers.fromJson(Map<String, dynamic> json) {
    return TotalUsers(
      total: json['total']?.toString() ?? '0',
      verified: json['verified']?.toString() ?? '0',
      active: json['active']?.toString() ?? '0',
    );
  }
}

class TotalRevenue {
  final String total;
  final String average;
  final String max;
  final String min;

  TotalRevenue({
    required this.total,
    required this.average,
    required this.max,
    required this.min,
  });

  factory TotalRevenue.fromJson(Map<String, dynamic> json) {
    return TotalRevenue(
      total: json['total']?.toString() ?? '0',
      average: json['average']?.toString() ?? '0',
      max: json['max']?.toString() ?? '0',
      min: json['min']?.toString() ?? '0',
    );
  }
}

class StationStat {
  final String id;
  final String name;
  final String code;
  final String bookings;
  final String revenue;

  StationStat({
    required this.id,
    required this.name,
    required this.code,
    required this.bookings,
    required this.revenue,
  });

  factory StationStat.fromJson(Map<String, dynamic> json) {
    return StationStat(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      bookings: json['bookings']?.toString() ?? '0',
      revenue: json['revenue']?.toString() ?? '0',
    );
  }
}

class Performance {
  final String id;
  final String name;
  final String buckleNumber;
  final String rating;
  final String completedBookings;
  final String totalRevenue;
  final String avgRating;

  Performance({
    required this.id,
    required this.name,
    required this.buckleNumber,
    required this.rating,
    required this.completedBookings,
    required this.totalRevenue,
    required this.avgRating,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      buckleNumber: json['buckleNumber'] ?? '',
      rating: json['rating']?.toString() ?? '0',
      completedBookings: json['completedBookings']?.toString() ?? '0',
      totalRevenue: json['totalRevenue']?.toString() ?? '0',
      avgRating: json['avgRating']?.toString() ?? '0',
    );
  }
}