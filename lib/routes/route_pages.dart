import 'package:coolie_admin/screen/coolie%20listing/coolie_screen.dart';
import 'package:coolie_admin/screen/coolie%20passenger/passenger_screen.dart';
import 'package:coolie_admin/screen/stations/stations_screen.dart';

import '/routes/route_name.dart';
import 'package:get/get.dart';

import '../screen/auth/sign_in.dart';
import '../screen/dashboard/dashboard_screen.dart';
import '../screen/splash/splash_screen.dart';

class RoutePages {
  static final List<GetPage> pages = [
    GetPage(name: RouteName.splash, page: () => SplashScreen()),
    GetPage(name: RouteName.home, page: () => DashBoardScreen()),
    GetPage(name: RouteName.signIn, page: () => SignIn()),
    GetPage(name: RouteName.coolieScreen, page: () => CoolieScreen()),
    GetPage(name: RouteName.passengerScreen, page: () => PassengerScreen()),
    GetPage(name: RouteName.station, page: () => StationsScreen()),
    // GetPage(name: RouteName.checkIn, page: () => CheckIn()),
    // GetPage(name: RouteName.travelHomeScreen, page: () => ),
    // GetPage(name: RouteName.transactionHistory, page: () => TransactionHistory()),
    // GetPage(name: RouteName.otpVerification, page: () => OtpVerification()),
  ];
}
