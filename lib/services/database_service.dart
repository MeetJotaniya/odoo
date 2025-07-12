import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import '../models/skill_model.dart';
import '../models/swap_request_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'skill_swap.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Users table
    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Name varchar(100) NOT NULL,
        Email varchar(100) UNIQUE NOT NULL,
        Password TEXT NOT NULL,
        Location varchar(100),
        Profile_photo TEXT,
        Privacy Boolean DEFAULT 1,
        Created_at TEXT DEFAULT (CURRENT_TIMESTAMP),
        Skills_offered INTEGER REFERENCES Skills_Offered (id),
        Skills_wanted INTEGER REFERENCES Skills_Wanted (id)
      )
    ''');

    // Create Skills_Offered table
    await db.execute('''
      CREATE TABLE Skills_Offered (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        skill_name varchar(100) NOT NULL
      )
    ''');

    // Create Skills_Wanted table
    await db.execute('''
      CREATE TABLE Skills_Wanted (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Skill_name varchar(100) NOT NULL
      )
    ''');

    // Create SwapRequests table
    await db.execute('''
      CREATE TABLE SwapRequests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        From_user_id INTEGER REFERENCES Users (id) ON DELETE CASCADE,
        To_user_id INTEGER REFERENCES Users (id) ON DELETE CASCADE,
        Offered_skiils varchar(100) NOT NULL,
        Requested_skills varchar(100) NOT NULL,
        Status TEXT CHECK (Status IN ('pending', 'accepted', 'rejected', 'cancelled')),
        Created_at TEXT DEFAULT (CURRENT_TIMESTAMP)
      )
    ''');

    // Create Availability table
    await db.execute('''
      CREATE TABLE Availability (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        User_id INTEGER NOT NULL REFERENCES Users (id) ON DELETE CASCADE,
        Day TEXT CHECK (Day IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
        Time_slot TEXT CHECK (Time_slot IN ('Morning', 'Afternoon', 'Evening'))
      )
    ''');

    // Insert default skills
    await _insertDefaultSkills(db);
    
    // Insert dummy users
    await _insertDummyUsers(db);
  }

  Future<void> _insertDummyUsers(Database db) async {
    final List<Map<String, dynamic>> dummyUsers = [
      {
        'Name': 'Marc Demo',
        'Email': 'marc@example.com',
        'Password': 'password123',
        'Location': 'New York',
        'Profile_photo': null,
        'Privacy': true,
        'Skills_offered': 1, // Web Development
        'Skills_wanted': 3, // Python Programming
      },
      {
        'Name': 'Mitchell',
        'Email': 'mitchell@example.com',
        'Password': 'password123',
        'Location': 'London',
        'Profile_photo': null,
        'Privacy': true,
        'Skills_offered': 2, // App Development
        'Skills_wanted': 11, // Excel, PowerPoint and Word
      },
      {
        'Name': 'Joe Wills',
        'Email': 'joe@example.com',
        'Password': 'password123',
        'Location': 'Berlin',
        'Profile_photo': null,
        'Privacy': true,
        'Skills_offered': 4, // Java Programming
        'Skills_wanted': 1, // Web Development
      },
    ];

    for (Map<String, dynamic> userData in dummyUsers) {
      await db.insert('Users', userData);
    }
  }

  Future<void> _insertDefaultSkills(Database db) async {
    final List<String> defaultSkills = [
      'Web Development',
      'App Development',
      'Python Programming',
      'Java Programming',
      'Database Management',
      'Cybersecurity Basics',
      'DSA',
      'Machine Learning',
      'Data Analysis',
      'Git and Github',
      'Excel, PowerPoint and Word',
    ];

    for (String skill in defaultSkills) {
      await db.insert('Skills_Offered', {'skill_name': skill});
      await db.insert('Skills_Wanted', {'Skill_name': skill});
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    try {
      final result = await db.insert('Users', user.toJson());
      print('Inserted user with id: $result');
      return result;
    } catch (e) {
      print('Insert user error: $e');
      return 0;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Users',
      where: 'Email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Users');
    return List.generate(maps.length, (i) => User.fromJson(maps[i]));
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'Users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'Users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Skill operations
  Future<List<Skill>> getSkillsOffered() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Skills_Offered');
    return List.generate(maps.length, (i) => Skill.fromJson(maps[i]));
  }

  Future<List<Skill>> getSkillsWanted() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Skills_Wanted');
    return List.generate(maps.length, (i) => Skill.fromJson(maps[i]));
  }

  // Swap Request operations
  Future<int> insertSwapRequest(SwapRequest request) async {
    final db = await database;
    return await db.insert('SwapRequests', request.toJson());
  }

  Future<List<SwapRequest>> getSwapRequestsByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'SwapRequests',
      where: 'From_user_id = ? OR To_user_id = ?',
      whereArgs: [userId, userId],
    );
    return List.generate(maps.length, (i) => SwapRequest.fromJson(maps[i]));
  }

  Future<int> updateSwapRequestStatus(int requestId, SwapRequestStatus status) async {
    final db = await database;
    return await db.update(
      'SwapRequests',
      {'Status': status.name},
      where: 'id = ?',
      whereArgs: [requestId],
    );
  }

  // Authentication
  Future<User?> authenticateUser(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
} 