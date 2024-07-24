import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UpdateOutcomes extends StatefulWidget {
  @override
  _UpdateOutcomesState createState() => _UpdateOutcomesState();
}

class _UpdateOutcomesState extends State<UpdateOutcomes> {
  late Future<List<Game>> _gamesFuture;
  List<Game> _games = [];
  Game? _selectedGame;
  final TextEditingController _homeScoreController = TextEditingController();
  final TextEditingController _awayScoreController = TextEditingController();
  late GameDataSource _gameDataSource;

  @override
  void initState() {
    super.initState();
    _gamesFuture = _fetchGames();
  }

  Future<List<Game>> _fetchGames() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/games/'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Game> games = data.map((json) => Game.fromJson(json)).toList();
      setState(() {
        _games = games;
        _gameDataSource = GameDataSource(games: _games);
      });
      return games;
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
      } else {
        print('Failed to submit results');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bet Outcomes Page', style: GoogleFonts.lobster(fontSize: 24)),
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
                    return SfDataGrid(
                      source: _gameDataSource,
                      columns: [
                        GridColumn(
                          columnName: 'gameId',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'ID',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'home',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Home',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'away',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Away',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'homeOdds',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Home Odds',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'awayOdds',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Away Odds',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'drawOdds',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Draw Odds',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'gameDate',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Date',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'status',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Status',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'outcome',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Outcome',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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
  final int gameId;
  final String home;
  final String away;
  final double homeOdds;
  final double awayOdds;
  final double drawOdds;
  final DateTime gameDate;
  final bool status;
  final String outcome;

  Game({
    required this.gameId,
    required this.home,
    required this.away,
    required this.homeOdds,
    required this.awayOdds,
    required this.drawOdds,
    required this.gameDate,
    required this.status,
    required this.outcome,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameId: json['game_id'],
      home: json['home'],
      away: json['away'],
      homeOdds: json['home_odds'],
      awayOdds: json['away_odds'],
      drawOdds: json['draw_odds'],
      gameDate: DateTime.parse(json['game_date']),
      status: json['status'],
      outcome: json['outcome'],
    );
  }
}

class GameDataSource extends DataGridSource {
  GameDataSource({required List<Game> games}) {
    _games = games
        .map<DataGridRow>((game) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'gameId', value: game.gameId),
              DataGridCell<String>(columnName: 'home', value: game.home),
              DataGridCell<String>(columnName: 'away', value: game.away),
                            DataGridCell<double>(
                  columnName: 'homeOdds', value: game.homeOdds),
              DataGridCell<double>(
                  columnName: 'awayOdds', value: game.awayOdds),
              DataGridCell<double>(
                  columnName: 'drawOdds', value: game.drawOdds),
              DataGridCell<DateTime>(
                  columnName: 'gameDate', value: game.gameDate),
              DataGridCell<bool>(columnName: 'status', value: game.status),
              DataGridCell<String>(columnName: 'outcome', value: game.outcome),
            ]))
        .toList();
  }

  List<DataGridRow> _games = [];

  @override
  List<DataGridRow> get rows => _games;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[0].value.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[1].value.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[2].value.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[3].value.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[4].value.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[5].value.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[6].value.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[7].value.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[8].value.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    ]);
  }
}

