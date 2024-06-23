import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bet Pulse',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF3A3A3A),
      ),
      initialRoute: "/",
      getPages: Routes.routes,
    );
  }
}
