import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateOutcomes extends StatefulWidget {
  @override
  _UpdateOutcomesState createState() => _UpdateOutcomesState();
}

class _UpdateOutcomesState extends State<UpdateOutcomes> {
  late Future<List<Game>> _gamesFuture;
  Game? _selectedGame;
  final TextEditingController _homeScoreController = TextEditingController();
  final TextEditingController _awayScoreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _gamesFuture = _fetchGames();
  }

  Future<List<Game>> _fetchGames() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/games/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  void _submitResults() async {
    if (_selectedGame == null) return;

    final String homeScore = _homeScoreController.text;
    final String awayScore = _awayScoreController.text;

    final Map<String, String> data = {
      "home_score": homeScore,
      "away_score": awayScore,
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/games/update-outcome/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Results submitted successfully');
        // Handle successful submission
      } else {
        print('Failed to submit results');
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
            Text('Bet Outcomes Page', style: GoogleFonts.lobster(fontSize: 24)),
        backgroundColor: const Color(0xFF3A3A3A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
                label: Text('Add Game', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Game>>(
                future: _gamesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final games = snapshot.data!;

                    return DataTable(
                      columns: [
                        DataColumn(
                            label: Text('Match',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Stadium',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Date',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Select',
                                style: TextStyle(color: Colors.white))),
                      ],
                      rows: games.map((game) {
                        return DataRow(
                          cells: [
                            DataCell(Text('${game.home} vs ${game.away}',
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(game.stadium,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(game.date,
                                style: TextStyle(color: Colors.white))),
                            DataCell(
                              Radio<Game>(
                                value: game,
                                groupValue: _selectedGame,
                                onChanged: (Game? value) {
                                  setState(() {
                                    _selectedGame = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
            if (_selectedGame != null) ...[
              TextField(
                controller: _homeScoreController,
                decoration: const InputDecoration(
                  labelText: 'Home Side',
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
                controller: _awayScoreController,
                decoration: const InputDecoration(
                  labelText: 'Away Side',
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
                onPressed: _submitResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Submit Result',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Game {
  final String home;
  final String away;
  final String stadium;
  final String date;

  Game(
      {required this.home,
      required this.away,
      required this.stadium,
      required this.date});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      home: json['home'],
      away: json['away'],
      stadium: json['stadium'],
      date: json['date'],
    );
  }
}
