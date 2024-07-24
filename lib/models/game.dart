class Game {
  final int gameId;
  final String home;
  final String away;
  final double homeOdds;
  final double awayOdds;
  final double drawOdds;
  final String gameDate;
  final bool status;
  final String outcome; // Assuming 'outcome' is always provided as per your JSON data

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
      homeOdds: (json['home_odds'] as num).toDouble(),
      awayOdds: (json['away_odds'] as num).toDouble(),
      drawOdds: (json['draw_odds'] as num).toDouble(),
      gameDate: json['game_date'],
      status: json['status'],
      outcome: json['outcome'],
    );
  }
}