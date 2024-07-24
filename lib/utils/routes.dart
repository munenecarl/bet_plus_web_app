import 'package:bet_plus_web_app/views/bet_booking_page.dart';
import 'package:get/get.dart';
import '../views/update_outcomes.dart';


class Routes {
  static final routes = [
    GetPage(name: "/", page: () => const BetBookingPage()),
    GetPage(name: "/update-outcome", page: () => UpdateOutcomes()),
  ];
}
