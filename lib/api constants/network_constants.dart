class NetworkConstants {
  // local Urls
  static const String baseUrl = 'https://coolie.itfuturz.in/';
  static const String imageURL = 'https://coolie.itfuturz.in/';

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
  static const String getAllCoolies = 'api/users/getAllCollies';
  static const String getAllPassengers = 'api/users/getAllUsers';
  static const String getStats = 'api/admin/stats';
  static const String updateCoolie = 'api/admin/collie/updateCollieProfile1';

  // Timeouts
  static const int sendTimeout = 30000; // 30 seconds
}
