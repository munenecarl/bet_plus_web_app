import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class BetBookingPage extends StatefulWidget {
  const BetBookingPage({super.key});

  @override
  _BetBookingPageState createState() => _BetBookingPageState();
}

class _BetBookingPageState extends State<BetBookingPage> {
  final TextEditingController _homeController = TextEditingController();
  final TextEditingController _awayController = TextEditingController();
  final TextEditingController _homeOddsController = TextEditingController();
  final TextEditingController _awayOddsController = TextEditingController();
  final TextEditingController _drawOddsController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() async {
    if (_selectedDate == null) return;

    final String home = _homeController.text;
    final String away = _awayController.text;
    final String homeOdds = _homeOddsController.text;
    final String awayOdds = _awayOddsController.text;
    final String drawOdds = _drawOddsController.text;
    final String gameDate = "${_selectedDate!.toLocal()}".split(' ')[0];

    final Map<String, String> data = {
      "home": home,
      "away": away,
      "home_odds": homeOdds,
      "away_odds": awayOdds,
      "draw_odds": drawOdds,
      "game_date": gameDate
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/games/add-game/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Data submitted successfully');
        // Handle successful submission
      } else {
        print('Failed to submit data');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
        // Handle error
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Bet Booking Page', style: GoogleFonts.lobster(fontSize: 24)),
        backgroundColor: const Color(0xFF3A3A3A),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/update-outcomes');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Update Games',
                style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF3A3A3A),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bet Pulse',
                style: GoogleFonts.lobster(
                  fontSize: 36,
                  color: const Color(0xFFFFC107),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _homeController,
                decoration: const InputDecoration(
                  labelText: 'Home Team',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _awayController,
                decoration: const InputDecoration(
                  labelText: 'Away Team',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _homeOddsController,
                decoration: const InputDecoration(
                  labelText: 'Home Odds',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _awayOddsController,
                decoration: const InputDecoration(
                  labelText: 'Away Odds',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _drawOddsController,
                decoration: const InputDecoration(
                  labelText: 'Draw Odds',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Pick Date',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
