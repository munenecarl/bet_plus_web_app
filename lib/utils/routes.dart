import 'package:bet_plus_web_app/pages/bet_booking_page.dart';
import 'package:bet_plus_web_app/pages/login.dart';
import 'package:bet_plus_web_app/pages/signup.dart';
import 'package:get/get.dart';

class Routes {
  static final routes = [
    GetPage(name: "/", page: () => const LoginPage()),
    GetPage(name: "/signup", page: () => const SignUpPage()),
    GetPage(name: "/chat", page: () => const BetBookingPage()),
  ];
}
