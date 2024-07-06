import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitData() {
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

    print(data); // Replace with your HTTP POST request logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildTextField(_homeController, 'Home Team'),
              const SizedBox(height: 10),
              _buildTextField(_awayController, 'Away Team'),
              const SizedBox(height: 10),
              _buildTextField(_homeOddsController, 'Home Odds'),
              const SizedBox(height: 10),
              _buildTextField(_awayOddsController, 'Away Odds'),
              const SizedBox(height: 10),
              _buildTextField(_drawOddsController, 'Draw Odds'),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Select Game Date'
                        : "${_selectedDate!.toLocal()}".split(' ')[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0), // Purple color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFFC107)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
