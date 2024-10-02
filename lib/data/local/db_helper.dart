import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  /// singleton
  DBHelper._();

  static final getInstance = DBHelper._();

  /// table note
  static const String tableNote = "note"; // Table name
  static const String columnNoteSno = "s_no"; //column
  static const String columnNoteTitle = "title"; //column
  static const String columnNoteDesc = "desc"; //column

  Database? myDB;

  /// db open
  ///
  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;

    /*if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }*/
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, "noteDB.db");
    print("Data Base Path $dbPath");

    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        print("crating table......");

        ///create all your tables here
        db.execute(
            "CREATE TABLE $tableNote ($columnNoteSno INTEGER PRIMARY KEY AUTOINCREMENT, $columnNoteTitle TEXT, $columnNoteDesc TEXT)");
      },
      version: 1,
      onOpen: (db) {
        print("Data base opended Successfully!");
      },
    );
  }

  ///
  /// all queries
  /// insertion
  Future<bool> addNote({required String mTitle, required String mDesc}) async {
    var db = await getDB();
    int rowsEffected = await db
        .insert(tableNote, {columnNoteTitle: mTitle, columnNoteDesc: mDesc});
    print("Row affected : $rowsEffected");
    return rowsEffected > 0;
  }

  /// reading all data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(tableNote);
    print("Fetched Notes: $mData");
    return mData;
  }

  /// Update Data
  Future<bool> updateNote(
      {required String title, required String desc, required int sno}) async {
    var db = await getDB();

    int rowEffected = await db.update(
      tableNote, {columnNoteTitle: title, columnNoteDesc: desc},
      where: "$columnNoteSno = ?",
      whereArgs: [sno],
      // where: "$columnNoteSno = $sno"
      // // whereArgs: [sno],
    );
    return rowEffected > 0;
  }

  /// delete note
  Future<bool> deleteNote({required int sno}) async {
    var db = await getDB();
    int rowsEffected = await db
        .delete(tableNote, where: "$columnNoteSno =  ? ", whereArgs: ["$sno"]);
    return rowsEffected > 0;
  }
}
