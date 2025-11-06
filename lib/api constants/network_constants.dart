class NetworkConstants {
  // local Urls
  static const String baseUrl = 'https://hpf47sfz-2500.inc1.devtunnels.ms/';
  static const String imageURL = 'https://hpf47sfz-2500.inc1.devtunnels.ms/';

  //Production Urls

  //Endpoints

  //   Authentications
  static const String signIn = 'api/admin/signin';
  static const String otpVerification = 'api/users/isVerifiedCollie';
  static const String sendOtp = 'api/users/signIn';
  static const String getCoolieProfile = 'api/users/collieProfile';
  static const String pendingApproval = 'api/admin/pendingApprovals';
  static const String getAllStation = 'api/admin/getAllStation';
  static const String approveCollie = 'api/admin/approveCollie';
  static const String addCollie = 'api/admin/collie/registerCollie';

  // Timeouts
  static const int sendTimeout = 30000; // 30 seconds
}
