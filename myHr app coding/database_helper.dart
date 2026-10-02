import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('myhr.db');

    return _database!;
  }

  Future<Database> _initDB(
    String fileName,
  ) async {
    final dbPath = await getDatabasesPath();

    final path = join(
      dbPath,
      fileName,
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(
    Database db,
    int version,
  ) async {
    // EMPLOYEE TABLE

    await db.execute('''
      CREATE TABLE employee(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_name TEXT,
        employee_id TEXT,
        department TEXT,
        position TEXT,
        email TEXT,
        experience TEXT,
        status TEXT
      )
    ''');

    // ATTENDANCE TABLE

    await db.execute('''
      CREATE TABLE attendance(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action TEXT,
        time TEXT
      )
    ''');

    // LEAVE TABLE

    await db.execute('''
      CREATE TABLE leave_request(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_name TEXT,
        employee_id TEXT,
        leave_type TEXT,
        reason TEXT,
        date TEXT,
        status TEXT
      )
    ''');

    // ANNOUNCEMENT TABLE

    await db.execute('''
      CREATE TABLE announcement(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        message TEXT
      )
    ''');

    // TASK TABLE

    await db.execute('''
      CREATE TABLE task(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        checked INTEGER
      )
    ''');
  }

  // ==========================
  // EMPLOYEE
  // ==========================

  Future<int> insertEmployee(
    Map<String, dynamic> row,
  ) async {
    final db = await instance.database;

    return await db.insert(
      'employee',
      row,
    );
  }

  Future<List<Map<String, dynamic>>>
      getEmployees() async {
    final db = await instance.database;

    return await db.query('employee');
  }

  // ==========================
  // ATTENDANCE
  // ==========================

  Future<int> insertAttendance(
    String action,
    String time,
  ) async {
    final db = await instance.database;

    return await db.insert(
      'attendance',
      {
        'action': action,
        'time': time,
      },
    );
  }

  Future<List<Map<String, dynamic>>>
      getAttendance() async {
    final db = await instance.database;

    return await db.query('attendance');
  }

  // ==========================
  // LEAVE
  // ==========================

  Future<int> insertLeave(
    Map<String, dynamic> row,
  ) async {
    final db = await instance.database;

    return await db.insert(
      'leave_request',
      row,
    );
  }

  Future<List<Map<String, dynamic>>>
      getLeaveRequests() async {
    final db = await instance.database;

    return await db.query(
      'leave_request',
    );
  }

  Future<int> updateLeaveStatus(
    int id,
    String status,
  ) async {
    final db = await instance.database;

    return await db.update(
      'leave_request',
      {
        'status': status,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================
  // ANNOUNCEMENT
  // ==========================

  Future<int> insertAnnouncement(
    String title,
    String message,
  ) async {
    final db = await instance.database;

    return await db.insert(
      'announcement',
      {
        'title': title,
        'message': message,
      },
    );
  }

  Future<List<Map<String, dynamic>>>
      getAnnouncements() async {
    final db = await instance.database;

    return await db.query(
      'announcement',
    );
  }

  // ==========================
  // TASK
  // ==========================

  Future<int> insertTask(
    String title,
  ) async {
    final db = await instance.database;

    return await db.insert(
      'task',
      {
        'title': title,
        'checked': 0,
      },
    );
  }

  Future<List<Map<String, dynamic>>>
      getTasks() async {
    final db = await instance.database;

    return await db.query('task');
  }

  Future<int> updateTask(
    int id,
    int checked,
  ) async {
    final db = await instance.database;

    return await db.update(
      'task',
      {
        'checked': checked,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(
    int id,
  ) async {
    final db = await instance.database;

    return await db.delete(
      'task',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================
  // CLOSE DATABASE
  // ==========================

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}