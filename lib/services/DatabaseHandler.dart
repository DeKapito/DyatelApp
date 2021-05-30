import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../report_model.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'dyatel.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE dyatel_reports(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, image TEXT NOT NULL, longitude REAL NOT NULL, latitude REAL NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertReport(Report report) async {
    final Database db = await initializeDB();
    var result = await db.insert('dyatel_reports', report.toMap());
    return result;
  }

  Future<List<Report>> retrieveReports() async {
    final Database db = await initializeDB();
    final List<Map<String, Object>> queryResult =
        await db.query('dyatel_reports');
    return queryResult.map((e) => Report.fromMap(e)).toList();
  }
}
