import 'package:db_sqlite/data/local/db_helper.dart';
import 'package:flutter/foundation.dart';

class DBProvider extends ChangeNotifier {
  DBHelper dbHelper;
  DBProvider({required this.dbHelper});
  List<Map<String, dynamic>> _mData = [];

  //events
  void addNote(String title, String desc) async {
    bool check = await dbHelper.addNote(mTitle: title, mDesc: desc);
    if (check) {
      _mData = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }

  void updateNote(String title, String desc, int sno) async {
    bool check = await dbHelper.updateNote(title: title, desc: desc, sno: sno);
    if (check) {
      _mData = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }

  void deleteNote(int sno) async {
    bool check = await dbHelper.deleteNote(sno: sno);
    if (check) {
      _mData = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getNotes() => _mData;

  void getInitialNotes() async {
    _mData = await dbHelper.getAllNotes();
    notifyListeners();
  }
}
